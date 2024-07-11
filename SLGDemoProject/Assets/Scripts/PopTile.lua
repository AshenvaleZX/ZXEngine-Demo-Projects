local PopTile = NewGameLogic()

function PopTile:Awake()
    self.BtnRedGO = self.gameObject:FindChild("Panel/BtnRed")
    self.BtnRedTrans = self.BtnRedGO:GetComponent("RectTransform")
    self.BtnRedText = self.BtnRedGO:FindChild("Text"):GetComponent("UITextRenderer")
    self.BtnRedGO:GetComponent("UIButton"):SetClickCallBack(self.OnBtnRedClick, self)

    self.BtnBlueGO = self.gameObject:FindChild("Panel/BtnBlue")
    self.BtnBlueTrans = self.BtnBlueGO:GetComponent("RectTransform")
    self.BtnBlueText = self.BtnBlueGO:FindChild("Text"):GetComponent("UITextRenderer")
    self.BtnBlueGO:GetComponent("UIButton"):SetClickCallBack(self.OnBtnBlueClick, self)

    self.BtnGreenGO = self.gameObject:FindChild("Panel/BtnGreen")
    self.BtnGreenTrans = self.BtnGreenGO:GetComponent("RectTransform")
    self.BtnGreenText = self.BtnGreenGO:FindChild("Text"):GetComponent("UITextRenderer")
    self.BtnGreenGO:GetComponent("UIButton"):SetClickCallBack(self.OnBtnGreenClick, self)
end

function PopTile:OnBtnRedClick()
    GetMapCamera().TileClickBlock = true

    if self.SelectedTileType == GlobalConst.TILE_CITY_2 then
        GetMapMgr():MarchToSelectedTile(GlobalConst.MARCH_TYPE_SOLO)
    else
        GetMapMgr():MarchToSelectedTile(GlobalConst.MARCH_TYPE_RALLY)
    end

    GetMapMgr():UnSelectTile()
end

function PopTile:OnBtnBlueClick()
    GetMapCamera().TileClickBlock = true

    if self.SelectedTileType == GlobalConst.TILE_CITY_1 then
        -- Nothing
    elseif self.SelectedTileType == GlobalConst.TILE_CITY_2 or math.floor(self.SelectedTileType / 100) == 3 then
        GetMapMgr():MarchToSelectedTile(GlobalConst.MARCH_TYPE_SCOUT)
    else
        GetMapMgr():MarchToSelectedTile(GlobalConst.MARCH_TYPE_SOLO)
    end

    GetMapMgr():UnSelectTile()
end

function PopTile:OnBtnGreenClick()
    GetMapCamera().TileClickBlock = true

    GetMapMgr():MarchToSelectedTile(GlobalConst.MARCH_TYPE_GATHER)

    GetMapMgr():UnSelectTile()
end

function PopTile:SetTileInfo(tile)
    self.SelectedTileType = tile.type

    if self.NameTextCom == nil then
        self.NameTextCom = self.gameObject:FindChild("Panel/TileInfo/Name"):GetComponent("UITextRenderer")
    end
    if self.PosTextCom == nil then
        self.PosTextCom = self.gameObject:FindChild("Panel/TileInfo/Coordinate"):GetComponent("UITextRenderer")
    end

    self.NameTextCom:SetText(GetMapMgr().TileTypeToName[tile.type])
    self.PosTextCom:SetText("(" .. tile.pos.x .. "," .. tile.pos.y .. ")")

    -- 自己的基地
    if tile.type == GlobalConst.TILE_CITY_1 then
        self.BtnRedGO:SetActive(false)
        self.BtnBlueGO:SetActive(true)
        self.BtnGreenGO:SetActive(false)

        self.BtnBlueText:SetText("Enter")
        self.BtnBlueTrans:SetLocalRectPosition(0, -41, 0)

    -- 别人的基地
    elseif tile.type == GlobalConst.TILE_CITY_2 then
        self.BtnRedGO:SetActive(true)
        self.BtnBlueGO:SetActive(true)
        self.BtnGreenGO:SetActive(false)

        self.BtnRedText:SetText("Attack")
        self.BtnBlueText:SetText("Scout")
        self.BtnRedTrans:SetLocalRectPosition(48, -41, 0)
        self.BtnBlueTrans:SetLocalRectPosition(-48, -41, 0)

    -- 资源点
    elseif math.floor(tile.type / 100) == 2 then
        self.BtnRedGO:SetActive(false)
        self.BtnBlueGO:SetActive(false)
        self.BtnGreenGO:SetActive(true)

        self.BtnGreenText:SetText("Gather")
        self.BtnGreenTrans:SetLocalRectPosition(0, -41, 0)

    -- 野怪
    elseif math.floor(tile.type / 100) == 3 then
        self.BtnRedGO:SetActive(true)
        self.BtnBlueGO:SetActive(true)
        self.BtnGreenGO:SetActive(false)

        self.BtnRedText:SetText("Rally")
        self.BtnBlueText:SetText("Scout")
        self.BtnRedTrans:SetLocalRectPosition(48, -41, 0)
        self.BtnBlueTrans:SetLocalRectPosition(-48, -41, 0)

    -- 其他
    else
        self.BtnRedGO:SetActive(false)
        self.BtnBlueGO:SetActive(true)
        self.BtnGreenGO:SetActive(false)

        self.BtnBlueText:SetText("Occupy")
        self.BtnBlueTrans:SetLocalRectPosition(0, -41, 0)
    end
end

return PopTile