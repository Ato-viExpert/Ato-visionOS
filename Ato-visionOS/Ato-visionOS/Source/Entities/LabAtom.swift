//
//  LabAtom.swift
//  Ato-visionOS
//
//  Created by ellllly on 7/24/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct Bond{
    let atomUUID: UUID /// 결합 상대 원자 고유 번호
    let bondType: Int /// 몇 중 결합인지(1, 2, 3)
}

class LabAtom: Atom {
    
    // MARK: - Propteries
    
    public let atomId = UUID() /// 원자 고유 번호(동일 원자들과 결합시 구분)
    public private(set) var moleculeId: UUID? /// 분자 고유 번호(동일 분자들과 결합시 구분)
    
    public let valenceElectrons: Int /// 초기 최외각 전자 수
    public private(set) var sharedElectrons: Int = 0 /// 결합에 쓴 전자 수
    public private(set) var bonds: [Bond] = [] /// 현재 결합 정보들
    public var currentElectronCount: Int { /// 현재 전자 수
        return (bonds.count * 2) + unpairedElectrons
    }
    public var unpairedElectrons: Int { /// 홀전자 수(결합 가능한 전자 수)
        return valenceElectrons - sharedElectrons
    }
    public private(set) var maxElectronCount: Int
    
    private let diffuseColor: UIColor /// 확산 색상
    private let emissiveColor: UIColor /// 발광 색상
    private let modelScale: Float /// 모델 크기
    private(set) var entity: Entity?
    private(set) var magnifiedEntity: Entity?
    private(set) var position: SIMD3<Float> = .zero
    
    // MARK: - Init
    
    init(
        atomicNumber: Int
    ) {
        guard let atomType = AtomType.from(atomicNumber: atomicNumber) else {
            fatalError("Invalid atomic number: \(atomicNumber)")
        }
        self.valenceElectrons = atomType.valenceElectrons
        self.maxElectronCount = atomType.orbit == 1 ? 2 : 8
        self.diffuseColor = atomType.diffuseColor
        self.emissiveColor = atomType.emissiveColor
        self.modelScale = atomType.modelScale
        super.init(
            atomicNumber: atomicNumber,
            symbol: atomType.symbol,
            electronShells: atomType.electronsPerOrbit
        )
    }
    
    // MARK: - Public Methods
    
    /// 분자 아이디 설정
    func setMoleculeId(_ id: UUID) {
        self.moleculeId = id
    }
    
    /// 공유 전자 수 증가
    func increaseSharedElectrons(by amount: Int) {
        sharedElectrons += amount
    }
    
    /// 공유 전자 수 감소
    func decreaseSharedElectrons(by amount: Int) {
        sharedElectrons = max(0, sharedElectrons - amount)
    }
    
    /// 결합 추가
    func addBond(_ bond: Bond) {
        guard !bonds.contains(where: { $0.atomUUID == bond.atomUUID }) else { return }
        bonds.append(bond)
        increaseSharedElectrons(by: bond.bondType)
    }
    
    /// 결합 제거
    func removeBond(_ bond: Bond) {
        if let index = bonds.firstIndex(where: { $0.atomUUID == bond.atomUUID }) {
            let removedBond = bonds[index]
            bonds.remove(at: index)
            self.moleculeId = nil
            decreaseSharedElectrons(by: removedBond.bondType)
        }
    }
    
    /// 모든 결합 제거
    func clearBonds() {
        bonds.removeAll()
        sharedElectrons = 0
    }

    
    /// 원자 위치 설정
    /// - Parameter newPosition: 원자 위치 SIMD3<Float> 값
    func setPosition(_ position: SIMD3<Float>) {
        entity?.position = position
    }
    
    /// 현재 원자가 결합한 대상 원자(LabAtom)를 MoleculeManager를 통해 찾아 반환
    /// - Parameters:
    ///   - id: 찾고자 하는 결합 상대 원자의 UUID
    ///   - manager: 원자가 속한 분자를 추적할 수 있는 MoleculeManager 인스턴스
    /// - Returns: UUID에 해당하는 결합된 LabAtom 인스턴스, 없을 경우 nil
    func findBondedAtom(by id: UUID, in manager: MoleculeManager) -> LabAtom? {
        guard let moleculeId = self.moleculeId,
              let molecule = manager.findMoleculeByUUID(moleculeId) else {
            return nil
        }
        return molecule.atoms.first(where: { $0.atomId == id })
    }
}


extension LabAtom {
    // MARK: - 3D 원자 로드 Methods
    
    /// 주어진 LabAtom의 속성(심볼, 스케일 등)을 기반으로 RealityKit 엔티티를 비동기적으로 로드하고 설정합니다.
    /// - Returns: 설정이 완료된 RealityKit 엔티티
    func loadEntity() async throws -> Entity {
        if let existing = entity {
            return existing
        }
        let root = try await Entity(named: symbol, in: realityKitContentBundle)
        
        await MainActor.run {
            root.name = atomId.uuidString
            root.scale = SIMD3<Float>(repeating: modelScale)
            
            let bounds = root.visualBounds(relativeTo: nil)
            let shape = ShapeResource.generateBox(size: bounds.extents)
            root.components.set(CollisionComponent(shapes: [shape]))
            root.components.set(InputTargetComponent())
        }
        self.entity = root
        return root
    }
}
// MARK: - 원자 상세보기 (확대) 관련

extension LabAtom {
    
    /// LabAtom의 물리적 특성과 전자 구조를 기반으로 확대용 Entity를 구성합니다.
    /// - Returns: 확대 표현용 원자 Entity
   @MainActor
    func loadMagnificationEntity() async -> Entity {
        let root =  Entity()
        root.name = "magnified_\(atomId.uuidString)"
        
        let nucleus = generateNucleus()
        root.addChild(nucleus)
        
        for (index, electronCount) in electronShells.enumerated() {
            if electronCount <= 0 { continue }
            
            if let ring = await generateRing(index: index, electronCount: electronCount) {
                startRingRotation(ring: ring, speed: 0.5 + 0.2 * Float(index))
                nucleus.addChild(ring)
            }
        }
        
        let bounds =  root.visualBounds(relativeTo: nil)
        let shape =  ShapeResource.generateBox(size: bounds.extents)
        root.components.set(CollisionComponent(shapes: [shape]))
        root.components.set(InputTargetComponent())
        magnifiedEntity = root
        return root
    }
    
    /// 원자핵 생성 (회전 중심)
    /// - Returns: 원자핵
    private func generateNucleus() -> Entity {
        let mesh = MeshResource.generateSphere(radius: 0.03)
        let color = diffuseColor.withAlphaComponent(0.7)
        let material = SimpleMaterial(color: color, isMetallic: true)
        let nucleus = ModelEntity(mesh: mesh, materials: [material])
        nucleus.name = "nucleus"
        return nucleus
    }

    /// 궤도 링 + 전자 생성
    /// - Parameters:
    ///   - index: 몇번째 링인지 Int 값
    ///   - electronCount: 링에 포함되야하는 전자 몇개인지 Int 값
    /// - Returns: 전자를 포함한 전자 궤도 링 반환
    private func generateRing(index: Int, electronCount: Int) async -> Entity? {
        let assetName = "ring\(index + 1)"
        do {
            let ring = try await Entity(named: assetName, in: realityKitContentBundle)
            await MainActor.run {
                ring.name = assetName
                ring.position = .zero
                ring.scale = [1, 1, 1]
                
                let bounds = ring.visualBounds(relativeTo: nil)
                let radius = bounds.extents.x / 2
                
                for i in 0..<electronCount {
                    let angle = Float(i) * (2 * .pi / Float(electronCount))
                    let x = cos(angle) * radius
                    let z = sin(angle) * radius
                    
                    let electronMesh = MeshResource.generateSphere(radius: 0.005)
                    let electronMaterial = SimpleMaterial(color: .white.withAlphaComponent(0.5), isMetallic: false)
                    let electron = ModelEntity(mesh: electronMesh, materials: [electronMaterial])
                    electron.position = [x, 0, z]
                    
                    ring.addChild(electron)
                }
            }
            return ring
        } catch {
            print("⚠️ Failed to load ring asset: \(error)")
            return nil
        }
    }

    /// 링 회전 시작 (비동기 Task)
    /// - Parameters:
    ///   - ring: 회전 시킬 링
    ///   - speed: 회전 속도
    private func startRingRotation(ring: Entity, speed: Float) {
        Task.detached {
            var time: Float = 0
            while true {
                time += 0.016
                
                let axis = normalize(SIMD3<Float>(
                    x: sin(time * 0.2),
                    y: cos(time * 0.3),
                    z: sin(time * 0.1 + .pi / 4)
                ))
                
                let angle = speed * 0.016
                let deltaRotation = simd_quatf(angle: angle, axis: axis)
                
                await MainActor.run {
                    ring.transform.rotation = deltaRotation * ring.transform.rotation
                }
                
                try? await Task.sleep(nanoseconds: 16_000_000)
            }
        }
    }
}

// MARK: - Equatable

extension LabAtom: Equatable {
    static func == (lhs: LabAtom, rhs: LabAtom) -> Bool {
        return lhs.atomId == rhs.atomId
    }
}
