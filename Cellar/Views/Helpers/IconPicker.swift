//
//  IconPicker.swift
//  Cellar
//
//  Created by Dani on 6/10/23.
//

import SwiftUI

struct IconPicker: View {
    let maxIconSize: CGFloat = 128
    
    @EnvironmentObject var context: Context
    
    @Binding var icon: NSImage?
    private var image: some View {
        if let icon {
            return Image(nsImage: icon)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .padding(0)
        } else {
            return Image(systemName: "plus")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .padding(10)
        }
    }
    private var outline: RoundedRectangle {
        RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
    }
    
    @State var isFilePickerPresent: Bool = false
    @State var isTargetedForDrop: Bool = false
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack {
            outline
                .stroke(lineWidth: 2)
                .foregroundStyle(isFocused ? Color.accentColor : .secondary)
                .frame(width: 40, height: 40)
            image
                .frame(width: 35, height: 35)
                .clipShape(outline)
        }
        .contentShape(outline)
        .onTapGesture(count: 2) {
            isFilePickerPresent = true
        }
        .focusable()
        .focusEffectDisabled()
        .focused($isFocused)
        .onPasteCommand(of: [.image]) { providers in
            guard let provider = providers.first else {
                return
            }
            getIcon(from: provider)
        }
        .onChange(of: isTargetedForDrop) {
            self.isFocused = isTargetedForDrop
        }
        .onDrop(of: [.image], isTargeted: $isTargetedForDrop) { providers in
            guard let provider = providers.first else {
                return false
            }
            getIcon(from: provider)
            return true
        }
        .fileImporter(isPresented: $isFilePickerPresent,
                      allowedContentTypes: [.image],
                      allowsMultipleSelection: false) { result in
            switch result {
            case .success(let urls):
                guard let url = urls.first else {
                    context.present(error: .other(nil))
                    return
                }
                if url.startAccessingSecurityScopedResource() {
                    defer { url.stopAccessingSecurityScopedResource() }
                    guard let data = try? Data(contentsOf: url),
                          let icon = NSImage(data: data) else {
                        context.present(error: .failureWhileSavingIcon)
                        return
                    }
                    if icon.size.width > maxIconSize || icon.size.height > maxIconSize {
                        print("too big")
                        let maxLength = max(icon.size.width, icon.size.height)
                        let scalingFactor = maxLength / maxIconSize
                        let newSize = NSSize(width: icon.size.width / scalingFactor,
                                             height: icon.size.height / scalingFactor)
                        print("new size: \(newSize)")
                        guard let newIcon = resize(image: icon, to: newSize) else {
                            context.present(error: .failureWhileSavingIcon)
                            return
                        }
                        self.icon = newIcon
                    } else {
                        self.icon = icon
                    }
                }
            case .failure(let error):
                context.present(error: .other(error))
            }
        }
        
    }
    
    func getIcon(from provider: NSItemProvider) {
        _ = provider.loadDataRepresentation(for: .image) { data, error in
            if let error {
                DispatchQueue.main.async {
                    context.present(error: .other(error))
                }
                return
            }
            if let data {
                DispatchQueue.main.async {
                    guard let icon = NSImage(data: data) else {
                        context.present(error: .failureWhileSavingIcon)
                        return
                    }
                    self.icon = icon
                }
                return
            }
            DispatchQueue.main.async {
                context.present(error: .other(nil))
            }
        }
    }
    
    func resize(image: NSImage, to size: NSSize) -> NSImage? {
        let frame = NSRect(origin: .zero, size: size)
        guard let representation = image.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }
        let image = NSImage(size: size, flipped: false, drawingHandler: { (_) -> Bool in
            return representation.draw(in: frame)
        })

        return image
    }
}

#Preview {
    IconPicker(icon: .constant(nil))
        .environmentObject(Context())
}
