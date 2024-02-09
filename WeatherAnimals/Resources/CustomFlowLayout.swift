//
//  CustomFlowLayout.swift
//  WeatherAnimals
//
//  Created by 김은상 on 1/28/24.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect),
              let collectionView = collectionView else { return nil }
        
        // 현재 화면에 보이는 헤더를 찾음
        let visibleHeaderAttributes = attributes.filter { $0.representedElementKind == UICollectionView.elementKindSectionHeader }
        
        // 현재 화면에 보이는 첫 번째 헤더의 인덱스를 찾음
        guard let firstVisibleHeaderAttributes = visibleHeaderAttributes.first else {
            return attributes
        }
        
        // 현재 보이는 헤더의 섹션 인덱스를 가져옴
        let firstVisibleHeaderSection = firstVisibleHeaderAttributes.indexPath.section
        
        // 다음 섹션 헤더의 인덱스를 찾음
        let nextHeaderSection = min(firstVisibleHeaderSection + 1, collectionView.numberOfSections - 1)
        
        // 다음 섹션 헤더의 레이아웃 속성을 가져옴
        let nextHeaderIndexPath = IndexPath(item: 0, section: nextHeaderSection)
        let nextHeaderAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: nextHeaderIndexPath)
        
        // 현재 화면에 보이는 헤더가 다음 섹션 헤더의 아래에 있는지 확인하고, 애니메이션으로 숨김 처리
        if let nextHeaderAttributes = nextHeaderAttributes,
           let currentHeader = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).first(where: { $0 is CollectionHeader }) as? CollectionHeader {
      
            
            let yOffset = collectionView.contentOffset.y
            if yOffset >= nextHeaderAttributes.frame.minY {
                let diff = nextHeaderAttributes.frame.minY - firstVisibleHeaderAttributes.frame.maxY
                let alpha = max(0, min(1, 1 - abs(diff) / firstVisibleHeaderAttributes.frame.height))
//                print(alpha)
//                currentHeader.setAlpha(alpha)
            } else {
//                currentHeader.setAlpha(1)
            }
        }

        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
