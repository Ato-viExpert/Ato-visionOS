//
//  DissociateCommand.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/21/25.
//

import RealityKit
import SwiftUI

/// `DissociateCommand`는 결합된 `MoleculeEntity`를 분리하여 각 구성 원자들을 독립적인 엔티티로 되돌리는 커맨드입니다.
/// Command 패턴을 따르며, undo 시에는 다시 하나의 분자로 복원합니다.
