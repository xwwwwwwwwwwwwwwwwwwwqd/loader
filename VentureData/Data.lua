local Players = game:GetService("Players")
local player = Players.LocalPlayer
local backpack = player.PlayerGui.hud.safezone.backpack

-- Harga ikan tanpa E$ atau C$, langsung angka
local FishPrices = {
    ["Helios Ray"] = 180,
    ["Snowcap Algae"] = 50,
    ["Icicle"] = 130,
    ["Hydra Haddock"] = 400,
}

-- Fungsi untuk menambahkan label harga
local function setPriceLabel(itemFrame, itemName)
    local price = FishPrices[itemName]
    if not price then return end

    -- Cek dan buat label kalau belum ada
    local priceLabel = itemFrame:FindFirstChild("PriceLabel")
    if not priceLabel then
        priceLabel = Instance.new("TextLabel")
        priceLabel.Name = "PriceLabel"
        priceLabel.AnchorPoint = Vector2.new(0.5, 0)
        priceLabel.Position = UDim2.new(0.5, 0, 0, 2)
        priceLabel.Size = UDim2.new(1, 0, 0, 12)
        priceLabel.BackgroundTransparency = 1
        priceLabel.BorderSizePixel = 0
        priceLabel.TextScaled = false
        priceLabel.TextWrapped = true
        priceLabel.TextXAlignment = Enum.TextXAlignment.Center
        priceLabel.Font = Enum.Font.GothamBold
        priceLabel.TextSize = 11
        priceLabel.Parent = itemFrame
    end

    priceLabel.Text = tostring(price)
    priceLabel.TextColor3 = Color3.fromRGB(80, 255, 80) -- hijau semua
end

-- Fungsi untuk menampilkan harga di hotbar
local function showHotbarPrices()
    for _, item in pairs(backpack.hotbar:GetChildren()) do
        if item:IsA("Frame") or item:IsA("ImageButton") then
            local name = item.Name
            setPriceLabel(item, name)
        end
    end
end

-- Fungsi untuk menampilkan harga di inventory
local function showInventoryPrices()
    for _, item in pairs(backpack.inventory.scroll:GetChildren()) do
        if item:IsA("Frame") or item:IsA("ImageButton") then
            local name = item.Name
            setPriceLabel(item, name)
        end
    end
end

-- Jalankan keduanya
showHotbarPrices()
showInventoryPrices()
