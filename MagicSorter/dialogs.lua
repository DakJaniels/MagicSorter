---@diagnostic disable: undefined-field, param-type-mismatch

local eventManager = GetEventManager()
local windowManager = GetWindowManager()
local animationManager = GetAnimationManager()

-- Constants (defined in dialogs_constants.lua)
local C = MagicSorterDialogs.Constants

-- Animation Update Functions
---@param animation AnimationTimeline
function MagicSorterDialogs.LogoAnimation_OnStop(animation)
    if not animation:GetAnimatedControl():IsHidden() then
        animation:GetTimeline():PlayFromStart()
    end
end

---@param animation AnimationTimeline
---@param progress number
function MagicSorterDialogs.LogoAnimation_UpdateFunction(animation, progress)
    local control = animation:GetAnimatedControl()
    local logo, logo1, logo2, logo3 = control.logo, control.logo1, control.logo2, control.logo3
    local base = C.RGB_WEIGHT_BASE
    local coeff = C.RGB_WEIGHT_COEFFICIENT
    local interval

    interval = zo_lerp(C.ALPHA_NONE, C.ALPHA_FULL, C.LOGO_ANIMATION_PROGRESS_MULTIPLIER * progress)
    if interval >= C.ALPHA_NONE and C.ALPHA_FULL >= interval then
        interval = zo_sin(interval * 2 * ZO_PI)
        logo1:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, base + coeff * interval)
        logo1:SetVertexColors(C.VERTEX_INDEX_1_PLUS_4, C.LOGO_COLOR_R_1, C.LOGO_COLOR_G_1, C.LOGO_COLOR_B_1, C.ALPHA_LOGO_INTERVAL_MULTIPLIER * interval)
        logo1:SetVertexColors(C.VERTEX_INDEX_2_PLUS_8, C.LOGO_COLOR_R_1, C.LOGO_COLOR_G_1, C.LOGO_COLOR_B_1, C.ALPHA_NONE)
        logo1:SetHidden(false)
    else
        logo1:SetHidden(true)
    end

    interval = zo_lerp(C.ALPHA_NONE, C.ALPHA_FULL, C.LOGO_ANIMATION_OFFSET_1 + C.LOGO_ANIMATION_PROGRESS_MULTIPLIER * progress)
    if interval >= C.ALPHA_NONE and C.ALPHA_FULL >= interval then
        interval = zo_sin(interval * 2 * ZO_PI)
        logo2:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, base + coeff * interval)
        logo2:SetAlpha(C.ALPHA_LOGO_INTERVAL_MULTIPLIER * interval)
        logo2:SetHidden(false)
        logo:SetAlpha(C.ALPHA_FULL - interval)
    else
        logo2:SetHidden(true)
        logo:SetAlpha(C.ALPHA_FULL)
    end

    interval = zo_lerp(C.ALPHA_NONE, C.ALPHA_FULL, C.LOGO_ANIMATION_OFFSET_2 + C.LOGO_ANIMATION_PROGRESS_MULTIPLIER * progress)
    if interval >= C.ALPHA_NONE and C.ALPHA_FULL >= interval then
        interval = zo_sin(interval * 2 * ZO_PI)
        logo3:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, base + coeff * interval)
        logo3:SetVertexColors(C.VERTEX_INDEX_2_PLUS_8, C.LOGO_COLOR_R_3, C.LOGO_COLOR_G_3, C.LOGO_COLOR_B_3, C.ALPHA_LOGO_INTERVAL_MULTIPLIER * interval)
        logo3:SetVertexColors(C.VERTEX_INDEX_1_PLUS_4, C.LOGO_COLOR_R_3, C.LOGO_COLOR_G_3, C.LOGO_COLOR_B_3, C.ALPHA_NONE)
        logo3:SetHidden(false)
    else
        logo3:SetHidden(true)
    end
end

---@param animation MagicSorter_DragTagHighlightAnimation
---@param progress number
function MagicSorterDialogs.DragTagHighlightAnimation_UpdateFunction(animation, progress)
    local control = animation:GetAnimatedControl()
    local backdrop = control:GetNamedChild("LabelBackdrop")
    backdrop:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, C.RGB_WEIGHT_DRAG_TAG_HIGHLIGHT_MIN + C.RGB_WEIGHT_DRAG_TAG_HIGHLIGHT_MAX * progress)
end

---@param animation MagicSorter_RemoveButtonHighlightAnimation
---@param progress number
function MagicSorterDialogs.RemoveButtonHighlightAnimation_UpdateFunction(animation, progress)
    local control = animation:GetAnimatedControl()
    control:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, C.RGB_WEIGHT_REMOVE_BUTTON_HIGHLIGHT_MIN + C.RGB_WEIGHT_REMOVE_BUTTON_HIGHLIGHT_MAX * progress)
end

---@param animation AnimationTimeline
---@param progress number
function MagicSorterDialogs.ButtonHighlightAnimation_UpdateFunction(animation, progress)
    local control = animation:GetAnimatedControl()
    local backdrop = control:GetNamedChild("Backdrop")
    local color = zo_lerp(C.COLOR_LERP_BUTTON_HIGHLIGHT_MIN, C.COLOR_LERP_BUTTON_HIGHLIGHT_MAX, progress)
    backdrop:SetColor(C.COLOR_LERP_BUTTON_HIGHLIGHT_MULTIPLIER * color, color, color, C.ALPHA_FULL)
    backdrop:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, C.RGB_WEIGHT_BUTTON_HIGHLIGHT_MIN + C.RGB_WEIGHT_BUTTON_HIGHLIGHT_MAX * progress)
end

---@param animation AnimationTimeline
---@param progress number
function MagicSorterDialogs.ToggleHoverAnimation_UpdateFunction(animation, progress)
    progress = ZO_EaseInCubic(progress)
    local backdrop = animation:GetAnimatedControl().backdrop
    ---@cast backdrop TextureControl
    backdrop:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, C.RGB_WEIGHT_TOGGLE_HOVER_MIN + C.RGB_WEIGHT_TOGGLE_HOVER_MAX * progress)
end

---@param animation AnimationTimeline
---@param progress number
function MagicSorterDialogs.ToggleSelectAnimation_UpdateFunction(animation, progress)
    progress = ZO_EaseInCubic(progress)
    local control = animation:GetAnimatedControl()
    local r = zo_lerp(C.COLOR_LERP_TOGGLE_SELECT_R_MIN, C.COLOR_LERP_TOGGLE_SELECT_R_MAX, progress)
    control.label:SetColor(r, C.ALPHA_FULL, C.ALPHA_FULL, C.ALPHA_FULL)
    r = zo_lerp(C.COLOR_LERP_TOGGLE_SELECT_R_BACKDROP_MIN, C.COLOR_LERP_TOGGLE_SELECT_R_BACKDROP_MAX, progress)
    local g = zo_lerp(C.COLOR_LERP_TOGGLE_SELECT_G_MIN, C.COLOR_LERP_TOGGLE_SELECT_G_MAX, progress)
    control.backdrop:SetColor(r, g, C.COLOR_LERP_TOGGLE_SELECT_B, C.ALPHA_FULL)
end

---@param animation AnimationTimeline
---@param progress number
function MagicSorterDialogs.TabButtonHighlightAnimation_UpdateFunction(animation, progress)
    local control = animation:GetAnimatedControl()
    local backdrop = control:GetNamedChild("Backdrop")
    local color1 = zo_lerp(C.COLOR_LERP_TAB_BUTTON_HIGHLIGHT_MIN, C.COLOR_LERP_TAB_BUTTON_HIGHLIGHT_MID, progress)
    local color2 = zo_lerp(C.COLOR_LERP_TAB_BUTTON_HIGHLIGHT_MID, C.COLOR_LERP_TAB_BUTTON_HIGHLIGHT_MAX, progress)
    backdrop:SetColor(color2, color1, color2, C.ALPHA_FULL)
    backdrop:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, C.RGB_WEIGHT_TAB_BUTTON_HIGHLIGHT_MIN + C.RGB_WEIGHT_TAB_BUTTON_HIGHLIGHT_MAX * progress)
end

---@param animation AnimationTimeline
---@param progress number
function MagicSorterDialogs.OptionButtonHighlightAnimation_UpdateFunction(animation, progress)
    progress = ZO_EaseInCubic(progress)
    local r = zo_lerp(C.COLOR_LERP_OPTION_BUTTON_R, C.COLOR_LERP_OPTION_BUTTON_R, progress)
    local g = zo_lerp(C.COLOR_LERP_OPTION_BUTTON_G_MIN, C.COLOR_LERP_OPTION_BUTTON_G_MAX, progress)
    local b = zo_lerp(C.COLOR_LERP_OPTION_BUTTON_B_MIN, C.COLOR_LERP_OPTION_BUTTON_B_MAX, progress)
    local c = zo_lerp(C.COLOR_LERP_OPTION_BUTTON_ICON_MIN, C.COLOR_LERP_OPTION_BUTTON_ICON_MAX, progress)
    local desat = zo_lerp(C.COLOR_LERP_OPTION_BUTTON_DESAT_MIN, C.COLOR_LERP_OPTION_BUTTON_DESAT_MAX, progress)
    local weight = zo_lerp(C.RGB_WEIGHT_OPTION_BUTTON_HIGHLIGHT_MIN, C.RGB_WEIGHT_OPTION_BUTTON_HIGHLIGHT_MAX, progress)

    local control = animation:GetAnimatedControl()
    local backdropTexture = control:GetNamedChild("Backdrop")
    local iconTexture = control:GetNamedChild("Icon")

    backdropTexture:SetColor(r, g, b, C.ALPHA_FULL)
    backdropTexture:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, weight)
    iconTexture:SetColor(c, c, c, C.ALPHA_FULL)
    iconTexture:SetDesaturation(desat)
end

---@param animation AnimationTimeline
---@param progress number
function MagicSorterDialogs.OptionButtonHoverAnimation_UpdateFunction(animation, progress)
    progress = ZO_EaseInCubic(progress)
    animation:GetAnimatedControl():GetNamedChild("Icon"):SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, C.RGB_WEIGHT_OPTION_BUTTON_HOVER_MIN + C.RGB_WEIGHT_OPTION_BUTTON_HOVER_MAX * progress)
end

---@param timeline AnimationTimeline
function MagicSorterDialogs.TopLevelBackdropAnimation_OnStop(timeline)
    local control = timeline:GetAnimation(1):GetAnimatedControl()
    if not timeline:IsPlaying() and control and not control:IsHidden() then
        timeline:PlayFromStart(1)
    end
end

---@param animation AnimationTimeline
---@param completedPlaying boolean
function MagicSorterDialogs.TopLevelBackdropAnimation_OnPlay(animation, completedPlaying)
    local control = animation:GetAnimatedControl()
    local underlay1 = control:GetNamedChild("Underlay1")
    local underlay2 = control:GetNamedChild("Underlay2")
    local texture0 = control:GetNamedChild("Ring1")
    local texture1 = control:GetNamedChild("Ring2")
    local texture2 = control:GetNamedChild("Ring3")

    texture0:SetBlendMode(TEX_BLEND_MODE_COLOR_DODGE)
    texture1:SetBlendMode(TEX_BLEND_MODE_COLOR_DODGE)
    texture2:SetBlendMode(TEX_BLEND_MODE_COLOR_DODGE)

    underlay1:SetVertexColors(C.VERTEX_INDEX_1, C.UNDERLAY1_COLOR_V1_R, C.UNDERLAY1_COLOR_V1_G, C.UNDERLAY1_COLOR_V1_B, C.ALPHA_FULL)
    underlay1:SetVertexColors(C.VERTEX_INDEX_2, C.UNDERLAY1_COLOR_V2_R, C.UNDERLAY1_COLOR_V2_G, C.UNDERLAY1_COLOR_V2_B, C.ALPHA_FULL)
    underlay1:SetVertexColors(C.VERTEX_INDEX_4, C.UNDERLAY1_COLOR_V4_R, C.UNDERLAY1_COLOR_V4_G, C.UNDERLAY1_COLOR_V4_B, C.ALPHA_FULL)
    underlay1:SetVertexColors(C.VERTEX_INDEX_8, C.UNDERLAY1_COLOR_V8_R, C.UNDERLAY1_COLOR_V8_G, C.UNDERLAY1_COLOR_V8_B, C.ALPHA_FULL)
    underlay1:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, C.RGB_WEIGHT_UNDERLAY1)

    underlay2:SetVertexColors(C.VERTEX_INDEX_8, C.UNDERLAY2_COLOR_V8_R, C.UNDERLAY2_COLOR_V8_G, C.UNDERLAY2_COLOR_V8_B, C.ALPHA_UNDERLAY2_VERTEX)
    underlay2:SetVertexColors(C.VERTEX_INDEX_4, C.UNDERLAY2_COLOR_V4_R, C.UNDERLAY2_COLOR_V4_G, C.UNDERLAY2_COLOR_V4_B, C.ALPHA_UNDERLAY2_VERTEX)
    underlay2:SetVertexColors(C.VERTEX_INDEX_2, C.UNDERLAY2_COLOR_V2_R, C.UNDERLAY2_COLOR_V2_G, C.UNDERLAY2_COLOR_V2_B, C.ALPHA_UNDERLAY2_VERTEX)
    underlay2:SetVertexColors(C.VERTEX_INDEX_1, C.UNDERLAY2_COLOR_V1_R, C.UNDERLAY2_COLOR_V1_G, C.UNDERLAY2_COLOR_V1_B, C.ALPHA_UNDERLAY2_VERTEX)
    underlay2:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, C.RGB_WEIGHT_UNDERLAY2)

    texture0:SetAlpha(C.ALPHA_NONE)
    texture1:SetAlpha(C.ALPHA_NONE)
    texture2:SetAlpha(C.ALPHA_NONE)
end

---@param animation AnimationTimeline
---@param progress number
function MagicSorterDialogs.TopLevelBackdropAnimation_UpdateFunction(animation, progress)
    local control = animation:GetAnimatedControl()
    if control:IsHidden() then
        control.backdropAnimation:Stop()
    else
        local PI = ZO_PI
        local PI2 = ZO_TWO_PI

        local underlay1 = control:GetNamedChild("Underlay1")
        local underlay2 = control:GetNamedChild("Underlay2")
        local texture0 = control:GetNamedChild("Ring1")
        local texture1 = control:GetNamedChild("Ring2")
        local texture2 = control:GetNamedChild("Ring3")

        local angleu = (progress * PI2) % PI2
        MAGIC_SORTER:RotateTexture(underlay1, angleu)
        MAGIC_SORTER:RotateTexture(underlay2, PI2 - angleu)

        local alphau = C.ALPHA_UNDERLAY_BASE * (C.ALPHA_FULL + zo_sin(PI2 * C.BACKDROP_ANIMATION_FREQUENCY * progress))
        underlay1:SetAlpha(C.ALPHA_UNDERLAY_BASE + C.ALPHA_UNDERLAY_RANGE * alphau)
        underlay2:SetAlpha(C.ALPHA_UNDERLAY_BASE + C.ALPHA_UNDERLAY_RANGE * (C.ALPHA_FULL - alphau))

        progress = (C.BACKDROP_ANIMATION_PROGRESS_MULTIPLIER * progress) % C.ALPHA_FULL
        local interval0 = progress
        local interval1 = (progress + C.BACKDROP_ANIMATION_INTERVAL_OFFSET_1) % C.ALPHA_FULL
        local interval2 = (progress + C.BACKDROP_ANIMATION_INTERVAL_OFFSET_2) % C.ALPHA_FULL

        local angle0 = PI2 * interval0
        local angle1 = PI2 * -interval1
        local angle2 = PI2 * interval2

        local loop0 = zo_sin(PI * interval0)
        local loop1 = zo_sin(PI * interval1)
        local loop2 = zo_sin(PI * interval2)

        local scale0 = C.BACKDROP_ANIMATION_SCALE_MIN + C.BACKDROP_ANIMATION_SCALE_MAX * (C.ALPHA_FULL - interval0)
        local scale1 = C.BACKDROP_ANIMATION_SCALE_MIN + C.BACKDROP_ANIMATION_SCALE_MAX * (C.ALPHA_FULL - interval1)
        local scale2 = C.BACKDROP_ANIMATION_SCALE_MIN + C.BACKDROP_ANIMATION_SCALE_MAX * (C.ALPHA_FULL - interval2)

        MAGIC_SORTER:RotateTexture(texture0, angle0, 0.5, 0.5, scale0, scale0)
        MAGIC_SORTER:RotateTexture(texture1, angle1, 0.5, 0.5, scale1, scale1)
        MAGIC_SORTER:RotateTexture(texture2, angle2, 0.5, 0.5, scale2, scale2)

        texture0:SetVertexColors(C.VERTEX_INDEX_2_PLUS_4, C.RING0_COLOR_V6_R, C.RING0_COLOR_V6_G, C.RING0_COLOR_V6_B, C.BACKDROP_ANIMATION_ALPHA_MULTIPLIER * zo_min(C.ALPHA_FULL, C.RING0_MULTIPLIER_1 * loop0))
        texture0:SetVertexColors(C.VERTEX_INDEX_1_PLUS_8, C.RING0_COLOR_V9_R, C.RING0_COLOR_V9_G, C.RING0_COLOR_V9_B, C.BACKDROP_ANIMATION_ALPHA_MULTIPLIER * zo_min(C.ALPHA_FULL, C.RING0_MULTIPLIER_2 * loop0))

        texture1:SetVertexColors(C.VERTEX_INDEX_2_PLUS_4, C.RING1_COLOR_V6_R, C.RING1_COLOR_V6_G, C.RING1_COLOR_V6_B, C.BACKDROP_ANIMATION_ALPHA_MULTIPLIER * zo_min(C.ALPHA_FULL, C.RING1_MULTIPLIER_1 * loop1))
        texture1:SetVertexColors(C.VERTEX_INDEX_1_PLUS_8, C.RING1_COLOR_V9_R, C.RING1_COLOR_V9_G, C.RING1_COLOR_V9_B, C.BACKDROP_ANIMATION_ALPHA_MULTIPLIER * zo_min(C.ALPHA_FULL, C.RING1_MULTIPLIER_2 * loop1))

        texture2:SetVertexColors(C.VERTEX_INDEX_1_PLUS_4, C.RING2_COLOR_V5_R, C.RING2_COLOR_V5_G, C.RING2_COLOR_V5_B, C.BACKDROP_ANIMATION_ALPHA_MULTIPLIER * zo_min(C.ALPHA_FULL, C.RING2_MULTIPLIER_1 * loop2))
        texture2:SetVertexColors(C.VERTEX_INDEX_2_PLUS_8, C.RING2_COLOR_V10_R, C.RING2_COLOR_V10_G, C.RING2_COLOR_V10_B, C.BACKDROP_ANIMATION_ALPHA_MULTIPLIER * zo_min(C.ALPHA_FULL, C.RING2_MULTIPLIER_2 * loop2))

        texture0:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, loop0 * C.RGB_WEIGHT_RING_MAX)
        texture1:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, loop1 * C.RGB_WEIGHT_RING_MAX)
        texture2:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, loop2 * C.RGB_WEIGHT_RING_MAX)
    end
end

-- Control Initialization Functions
---@param control MagicSorter_DataRow
function MagicSorterDialogs.DataRow_OnInitialized(control)
    control.label1 = control:GetNamedChild("Label1")
    control.label2 = control:GetNamedChild("Label2")
    control.label3 = control:GetNamedChild("Label3")
    control.label4 = control:GetNamedChild("Label4")
    control.SetupRow = function (self, rowWidth, rowHeight, columnWidths)
        rowWidth = rowWidth or C.DATA_ROW_DEFAULT_WIDTH
        rowHeight = rowHeight or C.DATA_ROW_DEFAULT_HEIGHT
        self:SetDimensions(rowWidth, rowHeight)
        self.label1:SetText("")
        self.label2:SetText("")
        self.label3:SetText("")
        self.label4:SetText("")
        if columnWidths then
            local numColumns = #columnWidths
            self.label1:SetHidden(C.VERTEX_INDEX_1 > numColumns)
            self.label2:SetHidden(C.VERTEX_INDEX_2 > numColumns)
            self.label3:SetHidden(3 > numColumns)
            self.label4:SetHidden(C.VERTEX_INDEX_4 > numColumns)
            if tonumber(columnWidths[1]) then self.label1:SetDimensions(columnWidths[1], rowHeight) end
            if tonumber(columnWidths[2]) then self.label2:SetDimensions(columnWidths[2], rowHeight) end
            if tonumber(columnWidths[3]) then self.label3:SetDimensions(columnWidths[3], rowHeight) end
            if tonumber(columnWidths[4]) then self.label4:SetDimensions(columnWidths[4], rowHeight) end
        end
    end
    control.UpdateColumns = function (self, values)
        if values then
            self.label1:SetText(values[1] or "")
            self.label2:SetText(values[2] or "")
            self.label3:SetText(values[3] or "")
            self.label4:SetText(values[4] or "")
        end
    end
end

---@param control MagicSorter_Label
function MagicSorterDialogs.Label_OnInitialized(control)
    control:GetParent():SetDimensions(control:GetDimensions())
end

---@param control TextureControl
function MagicSorterDialogs.LabelBackdrop_OnInitialized(control)
    control:SetVertexColors(C.VERTEX_INDEX_1, C.LABEL_BACKDROP_COLOR_V1_R, C.LABEL_BACKDROP_COLOR_V1_G, C.LABEL_BACKDROP_COLOR_V1_B, C.ALPHA_NONE)
    control:SetVertexColors(C.VERTEX_INDEX_2, C.LABEL_BACKDROP_COLOR_V2_R, C.LABEL_BACKDROP_COLOR_V2_G, C.LABEL_BACKDROP_COLOR_V2_B, C.ALPHA_FULL)
    control:SetVertexColors(C.VERTEX_INDEX_4, C.LABEL_BACKDROP_COLOR_V4_R, C.LABEL_BACKDROP_COLOR_V4_G, C.LABEL_BACKDROP_COLOR_V4_B, C.ALPHA_FULL)
    control:SetVertexColors(C.VERTEX_INDEX_8, C.LABEL_BACKDROP_COLOR_V8_R, C.LABEL_BACKDROP_COLOR_V8_G, C.LABEL_BACKDROP_COLOR_V8_B, C.ALPHA_NONE)
end

---@param control TextureControl
function MagicSorterDialogs.LabelBackdrop_OnTextureLoaded(control)
    control:SetVertexColors(C.VERTEX_INDEX_1, C.LABEL_BACKDROP_COLOR_V1_R, C.LABEL_BACKDROP_COLOR_V1_G, C.LABEL_BACKDROP_COLOR_V1_B, C.ALPHA_NONE)
    control:SetVertexColors(C.VERTEX_INDEX_2, C.LABEL_BACKDROP_COLOR_V2_R, C.LABEL_BACKDROP_COLOR_V2_G, C.LABEL_BACKDROP_COLOR_V2_B, C.ALPHA_FULL)
    control:SetVertexColors(C.VERTEX_INDEX_4, C.LABEL_BACKDROP_COLOR_V4_R, C.LABEL_BACKDROP_COLOR_V4_G, C.LABEL_BACKDROP_COLOR_V4_B, C.ALPHA_FULL)
    control:SetVertexColors(C.VERTEX_INDEX_8, C.LABEL_BACKDROP_COLOR_V8_R, C.LABEL_BACKDROP_COLOR_V8_G, C.LABEL_BACKDROP_COLOR_V8_B, C.ALPHA_NONE)
end

---@param control MagicSorter_Button
function MagicSorterDialogs.Button_OnInitialized(control)
    control.highlightAnimation = animationManager:CreateTimelineFromVirtual("MagicSorter_ButtonHighlightAnimation", control)
end

---@param control MagicSorter_Button
function MagicSorterDialogs.Button_OnMouseEnter(control)
    if control then
        control.highlightAnimation:PlayFromStart()
        if control.tooltip then
            ZO_Tooltips_ShowTextTooltip(control, BOTTOM, control.tooltip)
        end
    end
end

---@param control MagicSorter_Button
function MagicSorterDialogs.Button_OnMouseExit(control)
    if control then
        control.highlightAnimation:PlayFromEnd()
        if control.tooltip then
            ZO_Tooltips_HideTextTooltip()
        end
    end
end

---@param control MagicSorter_Toggle
function MagicSorterDialogs.Toggle_OnInitialized(control)
    control.isSelected = false
    control.backdrop = control:GetNamedChild("Backdrop")
    control.label = control:GetNamedChild("Label")
    control.highlightAnimation = animationManager:CreateTimelineFromVirtual("MagicSorter_ToggleHoverAnimation", control)
    control.toggleAnimation = animationManager:CreateTimelineFromVirtual("MagicSorter_ToggleSelectAnimation", control)
    control.IsSelected = function (self)
        return self.isSelected == true
    end
    control.SetLabel = function (self, text)
        self.label:SetText(text)
    end
    control.UserToggle = function (self)
        self:Toggle()
        if self.onToggled then
            self:onToggled()
        end
    end
    control.Toggle = function (self, selected)
        if nil ~= selected then
            self.isSelected = selected
        else
            self.isSelected = not self.isSelected
        end
        if self.isSelected then
            self.toggleAnimation:PlayForward()
        else
            self.toggleAnimation:PlayBackward()
        end
    end
end

---@param control MagicSorter_Toggle
function MagicSorterDialogs.Toggle_OnMouseEnter(control)
    control.highlightAnimation:PlayFromStart()
end

---@param control MagicSorter_Toggle
function MagicSorterDialogs.Toggle_OnMouseExit(control)
    control.highlightAnimation:PlayFromEnd()
end

---@param control MagicSorter_Toggle
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.Toggle_OnMouseDown(control, button, ctrl, alt, shift, command)
    control:UserToggle()
end

---@param control MagicSorter_TabButton
function MagicSorterDialogs.TabButton_OnInitialized(control)
    control.active = false
    control.backdrop = control:GetNamedChild("Backdrop")
    control.label = control:GetNamedChild("Label")
    control.highlightAnimation = animationManager:CreateTimelineFromVirtual("MagicSorter_TabButtonHighlightAnimation", control)
    control.SetInactive = function (self)
        self.active = false
        self.label:SetColor(C.TAB_BUTTON_INACTIVE_R, C.TAB_BUTTON_INACTIVE_G, C.TAB_BUTTON_INACTIVE_B, C.ALPHA_FULL)
    end
    control.SetActive = function (self)
        self.active = true
        self.label:SetColor(C.TAB_BUTTON_ACTIVE_R, C.TAB_BUTTON_ACTIVE_G, C.TAB_BUTTON_ACTIVE_B, C.ALPHA_FULL)
    end
end

---@param control MagicSorter_TabButton
function MagicSorterDialogs.TabButton_OnMouseEnter(control)
    control.highlightAnimation:PlayFromStart()
end

---@param control MagicSorter_TabButton
function MagicSorterDialogs.TabButton_OnMouseExit(control)
    control.highlightAnimation:PlayFromEnd()
end

---@param control MagicSorter_TabButton
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.TabButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    control:SetActive()
    if control.onMouseDown then
        control:onMouseDown()
    end
end

---@param control MagicSorter_OptionButton
function MagicSorterDialogs.OptionButton_OnInitialized(control)
    control.highlightAnimation = animationManager:CreateTimelineFromVirtual("MagicSorter_OptionButtonHighlightAnimation", control)
    control.hoverAnimation = animationManager:CreateTimelineFromVirtual("MagicSorter_OptionButtonHoverAnimation", control)
    control.backdropInset = control:GetNamedChild("BackdropInset")
    control.icon = control:GetNamedChild("Icon")
    control.label = control:GetNamedChild("Label")
    control.overlay = control:GetNamedChild("Overlay")
    control.overlayLabel = control:GetNamedChild("OverlayLabel")
    control.IsSelected = function ()
        return control.isSelected == true
    end
    control.Toggle = function (self, isSelected)
        if nil ~= isSelected then
            self.isSelected = isSelected
        else
            self.isSelected = not self.isSelected
        end
        self:Refresh()
        if self.onToggled then
            self:onToggled()
        end
    end
    control.Refresh = function ()
        if control:IsSelected() then
            control.highlightAnimation:PlayForward()
        else
            control.highlightAnimation:PlayBackward()
        end
    end
    control:Refresh()
end

---@param control MagicSorter_OptionButton
function MagicSorterDialogs.OptionButton_OnMouseEnter(control)
    control.hoverAnimation:PlayForward()
end

---@param control MagicSorter_OptionButton
function MagicSorterDialogs.OptionButton_OnMouseExit(control)
    control.hoverAnimation:PlayBackward()
end

---@param control MagicSorter_OptionButton
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.OptionButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    control:Toggle()
end

---@param control TextureControl
function MagicSorterDialogs.OptionButtonOverlay_OnMouseEnter(control)
    if control.tooltip then
        ZO_Tooltips_ShowTextTooltip(control, RIGHT, control.tooltip)
    end
end

---@param control TextureControl
function MagicSorterDialogs.OptionButtonOverlay_OnMouseExit(control)
    if control.tooltip then
        ZO_Tooltips_HideTextTooltip()
    end
end

---@param control TextureControl
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.OptionButtonOverlay_OnMouseDown(control, button, ctrl, alt, shift, command)
    control:GetParent():Toggle()
end

---@param control TextureControl
function MagicSorterDialogs.RemovableItemBackdrop_OnInitialized(control)
    control:SetVertexColors(C.VERTEX_INDEX_2_PLUS_8, C.REMOVABLE_ITEM_BACKDROP_COLOR_V10_R, C.REMOVABLE_ITEM_BACKDROP_COLOR_V10_G, C.REMOVABLE_ITEM_BACKDROP_COLOR_V10_B, C.ALPHA_FULL)
    control:SetVertexColors(C.VERTEX_INDEX_1_PLUS_4, C.REMOVABLE_ITEM_BACKDROP_COLOR_V5_R, C.REMOVABLE_ITEM_BACKDROP_COLOR_V5_G, C.REMOVABLE_ITEM_BACKDROP_COLOR_V5_B, C.ALPHA_FULL)
end

---@param control TextureControl
function MagicSorterDialogs.RemovableItemBackdrop_OnTextureLoaded(control)
    control:SetVertexColors(C.VERTEX_INDEX_2_PLUS_8, C.REMOVABLE_ITEM_BACKDROP_COLOR_V10_R, C.REMOVABLE_ITEM_BACKDROP_COLOR_V10_G, C.REMOVABLE_ITEM_BACKDROP_COLOR_V10_B, C.ALPHA_FULL)
    control:SetVertexColors(C.VERTEX_INDEX_1_PLUS_4, C.REMOVABLE_ITEM_BACKDROP_COLOR_V5_R, C.REMOVABLE_ITEM_BACKDROP_COLOR_V5_G, C.REMOVABLE_ITEM_BACKDROP_COLOR_V5_B, C.ALPHA_FULL)
end

---@param control TextureControl
function MagicSorterDialogs.RemovableItemRemoveButton_OnInitialized(control)
    control.highlightAnimation = animationManager:CreateTimelineFromVirtual("MagicSorter_RemoveButtonHighlightAnimation", control)
end

---@param control TextureControl
function MagicSorterDialogs.RemovableItemRemoveButton_OnMouseEnter(control)
    control.highlightAnimation:PlayForward()
end

---@param control TextureControl
function MagicSorterDialogs.RemovableItemRemoveButton_OnMouseExit(control)
    control.highlightAnimation:PlayBackward()
end

---@param control MagicSorter_DropBox
function MagicSorterDialogs.DropBox_OnInitialized(control)
    control.overlay = control:GetNamedChild("Overlay")
    control.overlayLabel = control.overlay:GetNamedChild("Label")
end

---@param control TextureControl
function MagicSorterDialogs.DropBoxTile_OnInitialized(control)
    control:SetVertexColors(C.VERTEX_INDEX_1_PLUS_4, C.DROPBOX_TILE_COLOR_V5_R, C.DROPBOX_TILE_COLOR_V5_G, C.DROPBOX_TILE_COLOR_V5_B, C.ALPHA_DROPBOX_TILE)
    control:SetVertexColors(C.VERTEX_INDEX_2_PLUS_8, C.DROPBOX_TILE_COLOR_V10_R, C.DROPBOX_TILE_COLOR_V10_G, C.DROPBOX_TILE_COLOR_V10_B, C.ALPHA_DROPBOX_TILE)
end

---@param control TextureControl
function MagicSorterDialogs.DropBoxOverlay_OnMouseEnter(control)
    if control.tooltip then
        ZO_Tooltips_ShowTextTooltip(control, RIGHT, control.tooltip)
    end
end

---@param control TextureControl
function MagicSorterDialogs.DropBoxOverlay_OnMouseExit(control)
    if control.tooltip then
        ZO_Tooltips_HideTextTooltip()
    end
end

---@param control LabelControl
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.AssignThemesButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    MagicSorter_ThemeAssignment:SetHouse(control:GetParent():GetParent().house)
    MAGIC_SORTER:SetDialogHidden("CategoryAssignment", true)
    MAGIC_SORTER:SetDialogHidden("ThemeAssignment", false)
end

---@param control LabelControl
function MagicSorterDialogs.AssignThemesButton_OnMouseEnter(control)
    control:SetColor(C.ASSIGN_THEMES_BUTTON_HOVER_R, C.ASSIGN_THEMES_BUTTON_HOVER_G, C.ASSIGN_THEMES_BUTTON_HOVER_B, C.ALPHA_FULL)
    control:GetNamedChild("Backdrop"):SetColor(C.ASSIGN_THEMES_BUTTON_BACKDROP_HOVER_R, C.ASSIGN_THEMES_BUTTON_BACKDROP_HOVER_G, C.ASSIGN_THEMES_BUTTON_BACKDROP_HOVER_B, C.ALPHA_FULL)
end

---@param control LabelControl
function MagicSorterDialogs.AssignThemesButton_OnMouseExit(control)
    control:SetColor(C.ASSIGN_THEMES_BUTTON_NORMAL_R, C.ASSIGN_THEMES_BUTTON_NORMAL_G, C.ASSIGN_THEMES_BUTTON_NORMAL_B, C.ALPHA_FULL)
    control:GetNamedChild("Backdrop"):SetColor(C.ASSIGN_THEMES_BUTTON_BACKDROP_NORMAL_R, C.ASSIGN_THEMES_BUTTON_BACKDROP_NORMAL_G, C.ASSIGN_THEMES_BUTTON_BACKDROP_NORMAL_B, C.ALPHA_FULL)
end

---@param control LabelControl
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.ThemeAssignments_OnMouseDown(control, button, ctrl, alt, shift, command)
    MagicSorter_ThemeAssignment:SetHouse(control:GetParent():GetParent().house)
    MAGIC_SORTER:SetDialogHidden("CategoryAssignment", true)
    MAGIC_SORTER:SetDialogHidden("ThemeAssignment", false)
end

---@param control MagicSorter_DragTag
function MagicSorterDialogs.DragTag_OnInitialized(control)
    control.highlightAnimation = animationManager:CreateTimelineFromVirtual("MagicSorter_DragTagHighlightAnimation", control)
end

---@param control MagicSorter_DragTag
function MagicSorterDialogs.DragTag_OnMoveStart(control)
    if not control.originalParent then
        control.originalParent = control:GetParent()
    end
    control:SetParent(MagicSorter_DragTopLevel)
end

---@param control MagicSorter_DragTag
function MagicSorterDialogs.DragTag_OnMoveStop(control)
    MAGIC_SORTER:OnDropCategoryTag(control)
    if control.originalParent then
        control:SetParent(control.originalParent)
    end
    zo_callLater(function ()
                     control:ClearAnchors()
                     control:SetAnchor(TOPLEFT, control:GetOwningWindow().categoryScrollContents, TOPLEFT, control.originalX, control.originalY)
                 end, C.DRAG_TAG_RESET_DELAY_MS)
end

---@param control MagicSorter_DragTag
function MagicSorterDialogs.DragTag_OnMouseEnter(control)
    control.highlightAnimation:PlayForward()
    if control.tooltip then
        ZO_Tooltips_ShowTextTooltip(control, LEFT, control.tooltip)
    end
end

---@param control MagicSorter_DragTag
function MagicSorterDialogs.DragTag_OnMouseExit(control)
    control.highlightAnimation:PlayBackward()
    if control.tooltip then
        ZO_Tooltips_HideTextTooltip()
    end
end

---@param control TextureControl
function MagicSorterDialogs.DragTagLabelBackdrop_OnInitialized(control)
    control:SetVertexColors(C.VERTEX_INDEX_2_PLUS_8, C.DRAG_TAG_LABEL_BACKDROP_COLOR_V10_R, C.DRAG_TAG_LABEL_BACKDROP_COLOR_V10_G, C.DRAG_TAG_LABEL_BACKDROP_COLOR_V10_B, C.ALPHA_FULL)
    control:SetVertexColors(C.VERTEX_INDEX_1_PLUS_4, C.DRAG_TAG_LABEL_BACKDROP_COLOR_V5_R, C.DRAG_TAG_LABEL_BACKDROP_COLOR_V5_G, C.DRAG_TAG_LABEL_BACKDROP_COLOR_V5_B, C.ALPHA_FULL)
end

---@param control TextureControl
function MagicSorterDialogs.DragTagLabelBackdrop_OnTextureLoaded(control)
    control:SetVertexColors(C.VERTEX_INDEX_2_PLUS_8, C.DRAG_TAG_LABEL_BACKDROP_COLOR_V10_R, C.DRAG_TAG_LABEL_BACKDROP_COLOR_V10_G, C.DRAG_TAG_LABEL_BACKDROP_COLOR_V10_B, C.ALPHA_FULL)
    control:SetVertexColors(C.VERTEX_INDEX_1_PLUS_4, C.DRAG_TAG_LABEL_BACKDROP_COLOR_V5_R, C.DRAG_TAG_LABEL_BACKDROP_COLOR_V5_G, C.DRAG_TAG_LABEL_BACKDROP_COLOR_V5_B, C.ALPHA_FULL)
end

---@param control MagicSorter_StatusDetailRow
function MagicSorterDialogs.StatusDetailRow_OnInitialized(control)
    control.backdrop = control:GetNamedChild("Backdrop")
    control.houseName = control:GetNamedChild("HouseName")
    control.houseCapacity = control:GetNamedChild("HouseCapacity")
    control.houseStatus = control:GetNamedChild("HouseStatus")
    control.SetHouse = function (self, houseId, houseName)
        self.houseId = houseId
        self.name = houseName
        self.houseName:SetText(houseName)
    end
    control.SetCapacity = function (self, capacity)
        self.houseCapacity:SetText(capacity)
    end
    control.SetStatus = function (self, status)
        self.houseStatus:SetText(status)
    end
    control.SetHeaderRow = function (self)
        self:SetHeight(C.STATUS_DETAIL_HEADER_HEIGHT)
        self.backdrop:SetVertexColors(C.VERTEX_INDEX_1_PLUS_4, C.STATUS_DETAIL_HEADER_COLOR_V5_R, C.STATUS_DETAIL_HEADER_COLOR_V5_G, C.STATUS_DETAIL_HEADER_COLOR_V5_B, C.ALPHA_STATUS_DETAIL_HEADER)
        self.backdrop:SetVertexColors(C.VERTEX_INDEX_2_PLUS_8, C.STATUS_DETAIL_HEADER_COLOR_V10_R, C.STATUS_DETAIL_HEADER_COLOR_V10_G, C.STATUS_DETAIL_HEADER_COLOR_V10_B, C.ALPHA_STATUS_DETAIL_HEADER)
        self.houseName:SetColor(C.STATUS_DETAIL_HEADER_TEXT_R, C.STATUS_DETAIL_HEADER_TEXT_G, C.STATUS_DETAIL_HEADER_TEXT_B, C.ALPHA_FULL)
        self.houseName:SetMaxLineCount(C.STATUS_DETAIL_HEADER_MAX_LINES)
        self.houseCapacity:SetColor(C.STATUS_DETAIL_HEADER_TEXT_R, C.STATUS_DETAIL_HEADER_TEXT_G, C.STATUS_DETAIL_HEADER_TEXT_B, C.ALPHA_FULL)
        self.houseCapacity:SetMaxLineCount(C.STATUS_DETAIL_HEADER_MAX_LINES)
        self.houseStatus:SetColor(C.STATUS_DETAIL_HEADER_TEXT_R, C.STATUS_DETAIL_HEADER_TEXT_G, C.STATUS_DETAIL_HEADER_TEXT_B, C.ALPHA_FULL)
        self.houseStatus:SetMaxLineCount(C.STATUS_DETAIL_HEADER_MAX_LINES)
    end
    control.SetComplete = function (self, complete)
        if self.houseId == GetCurrentZoneHouseId() then
            self.backdrop:SetVertexColors(C.VERTEX_INDEX_1_PLUS_4, C.STATUS_DETAIL_ACTIVE_COLOR_V5_R, C.STATUS_DETAIL_ACTIVE_COLOR_V5_G, C.STATUS_DETAIL_ACTIVE_COLOR_V5_B, C.ALPHA_STATUS_DETAIL_ACTIVE)
            self.backdrop:SetVertexColors(C.VERTEX_INDEX_2_PLUS_8, C.STATUS_DETAIL_ACTIVE_COLOR_V10_R, C.STATUS_DETAIL_ACTIVE_COLOR_V10_G, C.STATUS_DETAIL_ACTIVE_COLOR_V10_B, C.ALPHA_STATUS_DETAIL_ACTIVE)
            self.houseName:SetColor(C.ALPHA_FULL, C.ALPHA_FULL, C.ALPHA_FULL, C.ALPHA_FULL)
            self.houseCapacity:SetColor(C.ALPHA_FULL, C.ALPHA_FULL, C.ALPHA_FULL, C.ALPHA_FULL)
            self.houseStatus:SetColor(C.ALPHA_FULL, C.ALPHA_FULL, C.ALPHA_FULL, C.ALPHA_FULL)
        else
            if complete then
                self.backdrop:SetVertexColors(C.VERTEX_INDEX_1_PLUS_4, C.STATUS_DETAIL_COMPLETE_COLOR_V5_R, C.STATUS_DETAIL_COMPLETE_COLOR_V5_G, C.STATUS_DETAIL_COMPLETE_COLOR_V5_B, C.ALPHA_STATUS_DETAIL_COMPLETE)
                self.backdrop:SetVertexColors(C.VERTEX_INDEX_2_PLUS_8, C.STATUS_DETAIL_COMPLETE_COLOR_V10_R, C.STATUS_DETAIL_COMPLETE_COLOR_V10_G, C.STATUS_DETAIL_COMPLETE_COLOR_V10_B, C.ALPHA_STATUS_DETAIL_COMPLETE)
                self.houseName:SetColor(C.STATUS_DETAIL_COMPLETE_TEXT_R, C.STATUS_DETAIL_COMPLETE_TEXT_G, C.STATUS_DETAIL_COMPLETE_TEXT_B, C.ALPHA_FULL)
                self.houseCapacity:SetColor(C.STATUS_DETAIL_COMPLETE_TEXT_R, C.STATUS_DETAIL_COMPLETE_TEXT_G, C.STATUS_DETAIL_COMPLETE_TEXT_B, C.ALPHA_FULL)
                self.houseStatus:SetColor(C.STATUS_DETAIL_COMPLETE_TEXT_R, C.STATUS_DETAIL_COMPLETE_TEXT_G, C.STATUS_DETAIL_COMPLETE_TEXT_B, C.ALPHA_FULL)
            else
                self.backdrop:SetVertexColors(C.VERTEX_INDEX_1_PLUS_4, C.STATUS_DETAIL_INCOMPLETE_COLOR_V5_R, C.STATUS_DETAIL_INCOMPLETE_COLOR_V5_G, C.STATUS_DETAIL_INCOMPLETE_COLOR_V5_B, C.ALPHA_STATUS_DETAIL_COMPLETE)
                self.backdrop:SetVertexColors(C.VERTEX_INDEX_2_PLUS_8, C.STATUS_DETAIL_INCOMPLETE_COLOR_V10_R, C.STATUS_DETAIL_INCOMPLETE_COLOR_V10_G, C.STATUS_DETAIL_INCOMPLETE_COLOR_V10_B, C.ALPHA_STATUS_DETAIL_COMPLETE)
                self.houseName:SetColor(C.STATUS_DETAIL_INCOMPLETE_TEXT_R, C.STATUS_DETAIL_INCOMPLETE_TEXT_G, C.STATUS_DETAIL_INCOMPLETE_TEXT_B, C.ALPHA_FULL)
                self.houseCapacity:SetColor(C.STATUS_DETAIL_INCOMPLETE_TEXT_R, C.STATUS_DETAIL_INCOMPLETE_TEXT_G, C.STATUS_DETAIL_INCOMPLETE_TEXT_B, C.ALPHA_FULL)
                self.houseStatus:SetColor(C.STATUS_DETAIL_INCOMPLETE_TEXT_R, C.STATUS_DETAIL_INCOMPLETE_TEXT_G, C.STATUS_DETAIL_INCOMPLETE_TEXT_B, C.ALPHA_FULL)
            end
        end
    end
end

---@param control MagicSorter_StatusDetailRow
function MagicSorterDialogs.StatusDetailRow_OnMouseEnter(control)
    if control.houseId and control.houseId > 0 then
        local sortManager = MAGIC_SORTER:GetSortManager()
        local categories = MAGIC_SORTER:GetHouseCategoryAssigmentsString(control.houseId) or "No categories assigned"
        local capacityTraditional = tostring(sortManager:GetHouseCapacity(control.houseId, HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_ITEM) or "Unknown")
        local capacitySpecial = tostring(sortManager:GetHouseCapacity(control.houseId, HOUSING_FURNISHING_LIMIT_TYPE_HIGH_IMPACT_ITEM) or "Unknown")
        local tooltip = string.format("|cffff00%s\n\n|cffffffAvailable Slots\nTraditional: |c00ffff%s|cffffff\nSpecial: |c00ffff%s|cffffff\n\nAssigned Categories:\n|c00ffff%s|cffffff", control.name or "", capacityTraditional, capacitySpecial, categories)
        ZO_Tooltips_ShowTextTooltip(control, RIGHT, tooltip)
    end
end

---@param control MagicSorter_StatusDetailRow
function MagicSorterDialogs.StatusDetailRow_OnMouseExit(control)
    if control.houseId and control.houseId > 0 then
        ZO_Tooltips_HideTextTooltip()
    end
end

---@param control MagicSorter_TopLevelStandardLogoFooter
function MagicSorterDialogs.LogoFooter_OnInitialized(control)
    local height1 = C.LOGO_TEXTURE_HEIGHT_1
    local height2 = C.LOGO_TEXTURE_HEIGHT_2
    local height3 = C.LOGO_TEXTURE_HEIGHT_3
    control.logo = control:GetNamedChild("Logo")
    control.logo1 = control:GetNamedChild("Logo1")
    control.logo2 = control:GetNamedChild("Logo2")
    control.logo3 = control:GetNamedChild("Logo3")
    control.logo:SetVertexColors(C.VERTEX_INDEX_1_PLUS_4, C.LOGO_FOOTER_COLOR_V5_R, C.LOGO_FOOTER_COLOR_V5_G, C.LOGO_FOOTER_COLOR_V5_B, C.ALPHA_FULL)
    control.logo:SetVertexColors(C.VERTEX_INDEX_2_PLUS_8, C.LOGO_FOOTER_COLOR_V10_R, C.LOGO_FOOTER_COLOR_V10_G, C.LOGO_FOOTER_COLOR_V10_B, C.ALPHA_FULL)
    control.logo:SetTextureCoords(0, C.ALPHA_FULL, height2 - height1, height2)
    control.logo1:SetTextureCoords(0, C.ALPHA_FULL, C.ALPHA_NONE, height1)
    control.logo2:SetTextureCoords(0, C.ALPHA_FULL, height2 - height1, height2)
    control.logo3:SetTextureCoords(0, C.ALPHA_FULL, height3 - height1, height3)
    control.backdropAnimation = animationManager:CreateTimelineFromVirtual("MagicSorter_LogoAnimation", control)
end

---@param control MagicSorter_TopLevelStandardLogoFooter
---@param hidden boolean
function MagicSorterDialogs.LogoFooter_OnEffectivelyShown(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:PlayFromStart()
    end
end

---@param control Control
---@param hidden boolean
function MagicSorterDialogs.LogoFooter_OnEffectivelyHidden(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:Stop()
    end
end

---@param control Control
function MagicSorterDialogs.Logo_OnTextureLoaded(control)
    control:SetVertexColors(C.VERTEX_INDEX_1_PLUS_4, C.LOGO_FOOTER_COLOR_V5_R, C.LOGO_FOOTER_COLOR_V5_G, C.LOGO_FOOTER_COLOR_V5_B, C.ALPHA_FULL)
    control:SetVertexColors(C.VERTEX_INDEX_2_PLUS_8, C.LOGO_FOOTER_COLOR_V10_R, C.LOGO_FOOTER_COLOR_V10_G, C.LOGO_FOOTER_COLOR_V10_B, C.ALPHA_FULL)
end

---@param control MagicSorter_TopLevelMovable
function MagicSorterDialogs.TopLevelMovable_OnShow(control)
    MAGIC_SORTER:OnDialogShow(control)
end

---@param control MagicSorter_TopLevelMovable
function MagicSorterDialogs.TopLevelMovable_OnMoveStop(control)
    MAGIC_SORTER:OnDialogMoved(control)
end

-- House Selection Dialog
---@param control MagicSorter_HouseSelection
function MagicSorterDialogs.HouseSelection_OnInitialized(control)
    local topLevel = control
    control.optionButtons = {}
    local function OnSelectionChanged()
        topLevel:RefreshCount()
    end
    control.GetNumColumns = function ()
        local width = control.scrollPanel:GetWidth()
        local columns = zo_max(C.VERTEX_INDEX_1, zo_floor((width - C.HOUSE_SELECTION_PADDING) / C.HOUSE_SELECTION_BUTTON_SIZE))
        return columns
    end
    control.GetOptionButtonPosition = function (self, optionIndex)
        local columns = self:GetNumColumns()
        local x = C.HOUSE_SELECTION_PADDING + ((optionIndex - C.VERTEX_INDEX_1) % columns) * C.HOUSE_SELECTION_BUTTON_SIZE
        local y = C.HOUSE_SELECTION_PADDING + zo_floor((optionIndex - C.VERTEX_INDEX_1) / columns) * C.HOUSE_SELECTION_BUTTON_SIZE
        return x, y
    end
    control.CreateOptionButton = function ()
        local optionIndex = #control.optionButtons + C.VERTEX_INDEX_1
        local x, y = control:GetOptionButtonPosition(optionIndex)
        local optionButton = windowManager:CreateControlFromVirtual("HouseOptionButton", control.scrollContents, "MagicSorter_OptionButton", optionIndex)
        optionButton:SetDimensions(C.HOUSE_SELECTION_BUTTON_WIDTH, C.HOUSE_SELECTION_BUTTON_HEIGHT)
        optionButton:SetAnchor(TOPLEFT, control.scrollContents, TOPLEFT, x, y)
        optionButton.onToggled = OnSelectionChanged
        control.optionButtons[optionIndex] = optionButton
        return optionButton
    end
    control.RefreshCount = function ()
        local houses = control:GetSelectedHouses()
        local count = 0
        if houses then
            count = #houses
        end
        control.countLabel:SetText(string.format("%d house%s selected", count, count == 1 and "" or "s"))
    end
    control.Refresh = function ()
        local houses = MAGIC_SORTER:GetOwnedHouses()
        local optionIndex = 0
        for houseIndex, house in ipairs(houses) do
            local houseStats = MAGIC_SORTER:GetInventoryManager():GetHouseStatistics(house.houseId)
            local optionButton = control.optionButtons[houseIndex]
            if not optionButton then
                optionButton = control:CreateOptionButton()
            end
            optionIndex = optionIndex + 1
            local x, y = control:GetOptionButtonPosition(optionIndex)
            optionButton:ClearAnchors()
            optionButton:SetAnchor(TOPLEFT, control.scrollContents, TOPLEFT, x, y)
            local icon = optionButton:GetNamedChild("Icon")
            local label = optionButton:GetNamedChild("Label")
            icon:SetTexture(house.houseImage)
            icon:SetTextureCoords(C.HOUSE_ICON_TEXTURE_COORDS_MIN_U, C.HOUSE_ICON_TEXTURE_COORDS_MAX_U, C.HOUSE_ICON_TEXTURE_COORDS_MIN_V, C.HOUSE_ICON_TEXTURE_COORDS_MAX_V)
            icon:SetDimensions(C.HOUSE_ICON_WIDTH, C.HOUSE_ICON_HEIGHT)
            label:SetText(house.houseName)
            if houseStats then
                local lastUpdate = MAGIC_SORTER:GetInventoryManager():GetLastHouseUpdate(house.houseId) or C.SCROLL_SLIDER_ZERO_THRESHOLD
                local unknown = lastUpdate == C.SCROLL_SLIDER_ZERO_THRESHOLD
                local age = GetTimeStamp() - lastUpdate
                local ageHours = zo_min(zo_floor(age / 60 / 60), C.HOUSE_STATS_AGE_HOURS_MAX)
                local isOld = ageHours >= C.HOUSE_STATS_AGE_HOURS_THRESHOLD
                local lowImpactUsed = houseStats.limits[HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_ITEM] or C.SCROLL_SLIDER_ZERO_THRESHOLD
                local lowImpactLimit = houseStats.maxLimits[HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_ITEM] or C.SCROLL_SLIDER_ZERO_THRESHOLD
                local highImpactUsed = houseStats.limits[HOUSING_FURNISHING_LIMIT_TYPE_HIGH_IMPACT_ITEM] or C.SCROLL_SLIDER_ZERO_THRESHOLD
                local highImpactLimit = houseStats.maxLimits[HOUSING_FURNISHING_LIMIT_TYPE_HIGH_IMPACT_ITEM] or C.SCROLL_SLIDER_ZERO_THRESHOLD
                optionButton.overlayLabel:SetText(string.format("%d/%d%s", lowImpactUsed, lowImpactLimit, isOld and "*" or ""))
                if isOld then
                    optionButton.overlayLabel:SetColor(C.HOUSE_STATS_OLD_COLOR_R, C.HOUSE_STATS_OLD_COLOR_G, C.HOUSE_STATS_OLD_COLOR_B, C.ALPHA_FULL)
                else
                    optionButton.overlayLabel:SetColor(C.HOUSE_STATS_NORMAL_COLOR_R, C.HOUSE_STATS_NORMAL_COLOR_G, C.HOUSE_STATS_NORMAL_COLOR_B, C.ALPHA_FULL)
                end
                optionButton.overlay.tooltip = string.format("Furnishing Limit Usage\n%d of %d Traditional Used\n%d of %d Special Used%s", lowImpactUsed, lowImpactLimit, highImpactUsed, highImpactLimit, unknown and "\n\n* Current figures are unknown" or isOld and string.format("\n\n* Figures from %d+ hours ago", ageHours) or "")
                optionButton.overlay:SetHidden(false)
            else
                optionButton.overlay:SetHidden(true)
            end
            optionButton.house = house
            optionButton.isSelected = nil ~= MAGIC_SORTER:GetStorageHouse(house.houseId)
            optionButton:SetHidden(false)
            optionButton:Refresh()
        end
        local numHouses = #houses
        for index = numHouses + C.VERTEX_INDEX_1, #control.optionButtons do
            control.optionButtons[index]:SetHidden(true)
            control.optionButtons[index].house = nil
        end
        local columns = control:GetNumColumns()
        local maxY = zo_floor((numHouses - C.VERTEX_INDEX_1) / columns) * C.HOUSE_SELECTION_BUTTON_SIZE
        control.scrollSlider:SetMinMax(C.SCROLL_SLIDER_MIN_VALUE, maxY)
        control:RefreshCount()
    end
    control.GetSelectedHouses = function ()
        local houses = {}
        for houseIndex, optionButton in ipairs(control.optionButtons) do
            if optionButton.house and optionButton:IsSelected() then
                table.insert(houses, optionButton.house)
            end
        end
        return houses
    end
    control.Submit = function ()
        local houses = control:GetSelectedHouses()
        return MAGIC_SORTER:OnSubmitStorageHouses(houses)
    end
    control.backdropAnimation = animationManager:CreateTimelineFromVirtual("MagicSorter_TopLevelBackdropAnimation", control)
    if not control:IsHidden() then
        control.backdropAnimation:PlayFromStart()
    end
end

---@param control MagicSorter_HouseSelection
---@param hidden boolean
function MagicSorterDialogs.HouseSelection_OnEffectivelyShown(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:PlayFromStart()
    end
end

---@param control MagicSorter_HouseSelection
---@param hidden boolean
function MagicSorterDialogs.HouseSelection_OnEffectivelyHidden(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:Stop()
    end
end

---@param control MagicSorter_HouseSelection
function MagicSorterDialogs.HouseSelection_OnResizeStop(control)
    MAGIC_SORTER:OnDialogMoved(control)
    control:Refresh()
end

---@param control ScrollControl
function MagicSorterDialogs.HouseSelectionScrollPanel_OnInitialized(control)
    control:GetOwningWindow().scrollPanel = control
end

---@param control ScrollControl
---@param delta number
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.HouseSelectionScrollPanel_OnMouseWheel(control, delta, ctrl, alt, shift, command)
    local slider = control:GetOwningWindow().scrollSlider
    local value = slider:GetValue()
    if value == C.SCROLL_SLIDER_ZERO_THRESHOLD then
        value = C.SCROLL_SLIDER_ZERO_REPLACEMENT
    end
    slider:SetValue(value - (delta * C.HOUSE_SELECTION_SCROLL_MULTIPLIER))
end

---@param control Control
function MagicSorterDialogs.HouseSelectionScrollContents_OnInitialized(control)
    control:GetOwningWindow().scrollContents = control
end

---@param control SliderControl
function MagicSorterDialogs.HouseSelectionScrollSlider_OnInitialized(control)
    control:GetOwningWindow().scrollSlider = control
    control:SetValue(C.SCROLL_SLIDER_DEFAULT_VALUE)
end

---@param control SliderControl
---@param value number
---@param eventReason number
function MagicSorterDialogs.HouseSelectionScrollSlider_OnValueChanged(control, value, eventReason)
    control:GetOwningWindow().scrollPanel:SetVerticalScroll(value)
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.HouseSelectionCloseButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    MAGIC_SORTER:SetDialogHidden("HouseSelection", true)
end

---@param control MagicSorter_CenterLabel
function MagicSorterDialogs.HouseSelectionCountLabel_OnInitialized(control)
    control:GetOwningWindow().countLabel = control:GetNamedChild("Label")
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.HouseSelectionNextButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    if control:GetOwningWindow():Submit() then
        MAGIC_SORTER:SetDialogHidden("HouseSelection", true)
        MAGIC_SORTER:SetDialogHidden("CategoryAssignment", false)
    end
end

-- Category Assignment Dialog
---@param control MagicSorter_CategoryAssignment
function MagicSorterDialogs.CategoryAssignment_OnInitialized(control)
    local topLevel = control
    local function AssignedCategoryComparer(catA, catB)
        return catB.name > catA.name
    end
    local function HouseNameComparer(houseA, houseB)
        return houseB.houseName > houseA.houseName
    end
    local assignedCategoryControls = {}
    control.assignedCategoryPool = ZO_ControlPool:New("MagicSorter_RemovableItem", MagicSorter_CategoryAssignment)
    control.ResetAssignedCategoryControlPool = function ()
        control.assignedCategoryPool:ReleaseAllObjects()
        for _, controlItem in ipairs(assignedCategoryControls) do
            controlItem:SetHidden(true)
            controlItem:ClearAnchors()
            controlItem:SetParent(GuiRoot)
        end
        assignedCategoryControls = {}
    end
    control.CreateAssignedCategory = function (self, parentControl, houseId, categoryId, categoryName, offsetX, offsetY, width, height)
        local controlItem, key = self.assignedCategoryPool:AcquireObject()
        table.insert(assignedCategoryControls, controlItem)
        controlItem.poolKey = key
        controlItem.houseId = houseId
        controlItem.categoryId = categoryId
        controlItem:SetDimensions(width or C.CATEGORY_ASSIGNMENT_REMOVABLE_ITEM_WIDTH, height or C.CATEGORY_ASSIGNMENT_REMOVABLE_ITEM_HEIGHT)
        controlItem:ClearAnchors()
        controlItem:SetParent(parentControl)
        controlItem:SetSimpleAnchorParent(offsetX, offsetY)
        local removeButton = controlItem:GetNamedChild("RemoveButton")
        removeButton:SetHandler("OnMouseDown", function ()
            MAGIC_SORTER:UnassignCategoryFromHouse(houseId, categoryId)
            topLevel:Refresh()
        end)
        removeButton:SetDrawTier(C.CATEGORY_ASSIGNMENT_REMOVE_BUTTON_DRAW_TIER)
        removeButton:SetDrawLayer(C.CATEGORY_ASSIGNMENT_REMOVE_BUTTON_DRAW_LAYER)
        removeButton:SetDrawLevel(C.CATEGORY_ASSIGNMENT_REMOVE_BUTTON_DRAW_LEVEL)
        controlItem:GetNamedChild("Label"):SetText(categoryName)
        controlItem:SetHidden(false)
        return controlItem
    end
    control.categoryTags = {}
    control.CreateCategoryTag = function (self, category)
        local categoryId = category.id
        local categoryTag = windowManager:CreateControlFromVirtual("CategoryTag", self.categoryScrollContents, "MagicSorter_DragTag", categoryId)
        self.categoryTags[categoryId] = categoryTag
        categoryTag.category = category
        categoryTag:SetParent(self.categoryScrollContents)
        categoryTag:GetNamedChild("Label"):SetText(category.displayName)
        return categoryTag
    end
    control.CreateHouseBox = function (self, house)
        local houseId = house.houseId
        local houseBox = windowManager:CreateControlFromVirtual("HouseBox", self.houseScrollContents, "MagicSorter_DropBox", houseId)
        self.houseBoxes[houseId] = houseBox
        houseBox.house = house
        houseBox:SetParent(self.houseScrollContents)
        houseBox:SetDimensions(C.CATEGORY_ASSIGNMENT_HOUSE_BOX_WIDTH, C.CATEGORY_ASSIGNMENT_HOUSE_BOX_HEIGHT)
        houseBox:GetNamedChild("Label"):SetText(house.houseName)
        houseBox:GetNamedChild("TileBackdrop"):SetTexture(house.houseImage)
        houseBox:GetNamedChild("TileBackdrop"):SetTextureCoords(C.CATEGORY_ASSIGNMENT_HOUSE_BOX_TILE_MIN_U, C.CATEGORY_ASSIGNMENT_HOUSE_BOX_TILE_MAX_U, C.CATEGORY_ASSIGNMENT_HOUSE_BOX_TILE_MIN_V, C.CATEGORY_ASSIGNMENT_HOUSE_BOX_TILE_MAX_V)
        return houseBox
    end
    control.RefreshScrollSlider = function ()
        local containerHeight = control.houseScrollPanel:GetHeight()
        local houseHeight = control.houseScrollContents:GetHeight()
        local houseViewHeight = houseHeight - containerHeight
        control.houseScrollSlider:SetMinMax(C.SCROLL_SLIDER_MIN_VALUE, zo_max(C.SCROLL_SLIDER_ZERO_REPLACEMENT, houseViewHeight))
        local categoryHeight = control.categoryScrollContents:GetHeight()
        local categoryViewHeight = categoryHeight - containerHeight
        control.categoryScrollSlider:SetMinMax(C.SCROLL_SLIDER_MIN_VALUE, zo_max(C.SCROLL_SLIDER_ZERO_REPLACEMENT, categoryViewHeight))
    end
    control.RefreshScrollContents = function ()
        local _, minY, _, maxY = control.houseScrollPanel:GetScreenRect()
        local numVisible = 0
        for _, houseBox in pairs(control.houseBoxes) do
            local y1, y2 = houseBox:GetTop(), houseBox:GetBottom()
            if houseBox.active and ((y1 >= minY and maxY >= y1) or (y2 >= minY and maxY >= y2)) then
                houseBox:SetHidden(false)
                numVisible = numVisible + 1
            else
                houseBox:SetHidden(true)
            end
        end
    end
    control.Refresh = function ()
        control:ResetAssignedCategoryControlPool()
        if not control.houseBoxes then
            control.houseBoxes = {}
        end
        local houses = MAGIC_SORTER:GetStorageHouses()
        local activeHouses = {}
        for houseId, house in pairs(houses) do
            local houseBox = control.houseBoxes[house.houseId]
            if not houseBox then
                houseBox = control:CreateHouseBox(house)
            end
            houseBox.active = true
            activeHouses[houseId] = true
        end
        for houseId, houseBox in pairs(control.houseBoxes) do
            if not activeHouses[houseId] then
                houseBox:SetHidden(true)
                houseBox.active = false
            end
        end
        local sortedBoxes = {}
        for _, houseBox in pairs(control.houseBoxes) do
            table.insert(sortedBoxes, houseBox)
        end
        table.sort(sortedBoxes, function (boxA, boxB) return boxB.house.houseName > boxA.house.houseName end)
        local houseY = C.CATEGORY_ASSIGNMENT_HOUSE_START_Y
        local tagY
        for houseIndex, houseBox in ipairs(sortedBoxes) do
            local houseId = houseBox.house.houseId
            houseBox:ClearAnchors()
            if activeHouses[houseId] then
                local themes = houseBox.house.assignedThemeIds or {}
                local themeCount = NonContiguousCount(themes)
                local themeCountText = themeCount == C.SCROLL_SLIDER_ZERO_THRESHOLD and "All" or tostring(themeCount)
                local houseStats = MAGIC_SORTER:GetInventoryManager():GetHouseStatistics(houseId)
                if houseStats then
                    local lastUpdate = MAGIC_SORTER:GetInventoryManager():GetLastHouseUpdate(houseId) or C.SCROLL_SLIDER_ZERO_THRESHOLD
                    local unknown = lastUpdate == C.SCROLL_SLIDER_ZERO_THRESHOLD
                    local age = GetTimeStamp() - lastUpdate
                    local ageHours = zo_min(zo_floor(age / 60 / 60), C.HOUSE_STATS_AGE_HOURS_MAX)
                    local isOld = ageHours >= C.HOUSE_STATS_AGE_HOURS_THRESHOLD
                    local lowImpactUsed = houseStats.limits[HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_ITEM] or C.SCROLL_SLIDER_ZERO_THRESHOLD
                    local lowImpactLimit = houseStats.maxLimits[HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_ITEM] or C.SCROLL_SLIDER_ZERO_THRESHOLD
                    local highImpactUsed = houseStats.limits[HOUSING_FURNISHING_LIMIT_TYPE_HIGH_IMPACT_ITEM] or C.SCROLL_SLIDER_ZERO_THRESHOLD
                    local highImpactLimit = houseStats.maxLimits[HOUSING_FURNISHING_LIMIT_TYPE_HIGH_IMPACT_ITEM] or C.SCROLL_SLIDER_ZERO_THRESHOLD
                    local limitText = string.format("%d/%d%s", lowImpactUsed, lowImpactLimit, isOld and "*" or "")
                    houseBox.overlayLabel:SetText(limitText)
                    if isOld then
                        houseBox.overlayLabel:SetColor(C.HOUSE_STATS_OLD_COLOR_R, C.HOUSE_STATS_OLD_COLOR_G, C.HOUSE_STATS_OLD_COLOR_B, C.ALPHA_FULL)
                    else
                        houseBox.overlayLabel:SetColor(C.HOUSE_STATS_NORMAL_COLOR_R, C.HOUSE_STATS_NORMAL_COLOR_G, C.HOUSE_STATS_NORMAL_COLOR_B, C.ALPHA_FULL)
                    end
                    local tooltipLimits = string.format("Furnishing Limit Usage\n%d of %d Traditional Used\n%d of %d Special Used%s", lowImpactUsed, lowImpactLimit, highImpactUsed, highImpactLimit, unknown and "\n\n* Current figures are unknown" or isOld and string.format("\n\n* Figures from %d+ hours ago", ageHours) or "")
                    local tooltipThemes
                    if themes then
                        local themeNames = MAGIC_SORTER:GetSortManager().FurnitureThemes
                        local themeList = {}
                        for themeId in pairs(themes) do
                            table.insert(themeList, themeNames[themeId] or "")
                        end
                        table.sort(themeList)
                        if #themeList > 0 then
                            tooltipThemes = table.concat(themeList, "\n")
                        end
                    end
                    houseBox.overlay.tooltip = string.format("%s%s", tooltipLimits, tooltipThemes and string.format("\n\n%s", tooltipThemes) or "")
                    houseBox.overlay:SetHidden(false)
                else
                    houseBox.overlay:SetHidden(true)
                end
                houseBox:GetNamedChild("AssignThemes"):GetNamedChild("ThemeAssignments"):SetText(string.format("(%s assigned)", themeCountText))
                local houseHeight = C.CATEGORY_ASSIGNMENT_HOUSE_HEIGHT_BASE
                houseBox:SetSimpleAnchorParent(C.SCROLL_SLIDER_ZERO_THRESHOLD, houseY)
                tagY = houseHeight
                local assignedCategories = MAGIC_SORTER:GetHouseCategoryAssignments(houseId)
                local assignedParentCategories = {}
                local assignedCategoryTable = {}
                local needsCategorizationId = MAGIC_SORTER.FURNITURE_NEEDS_CATEGORIZATION_CATEGORY_ID
                for _, category in ipairs(assignedCategories) do
                    table.insert(assignedCategoryTable, category)
                    -- Exclude "Needs Categorization" from parent category filtering since it's a special fake category
                    if category.parentId == C.SCROLL_SLIDER_ZERO_THRESHOLD and category.id ~= needsCategorizationId then
                        assignedParentCategories[category.id] = true
                    end
                end
                if #assignedCategoryTable ~= C.SCROLL_SLIDER_ZERO_THRESHOLD then
                    table.sort(assignedCategoryTable, AssignedCategoryComparer)
                    for index, category in ipairs(assignedCategoryTable) do
                        -- Always show "Needs Categorization" and don't filter it based on parent category logic
                        if category.id == needsCategorizationId or not assignedParentCategories[category.parentId] then
                            control:CreateAssignedCategory(houseBox, houseId, category.id, category.displayName, C.CATEGORY_ASSIGNMENT_CATEGORY_ITEM_OFFSET_X, tagY, C.CATEGORY_ASSIGNMENT_CATEGORY_ITEM_WIDTH, C.CATEGORY_ASSIGNMENT_CATEGORY_ITEM_HEIGHT)
                            tagY = tagY + C.CATEGORY_ASSIGNMENT_CATEGORY_HEIGHT
                            houseHeight = houseHeight + C.CATEGORY_ASSIGNMENT_CATEGORY_HEIGHT
                        end
                    end
                end
                houseHeight = houseHeight + C.CATEGORY_ASSIGNMENT_HOUSE_PADDING
                houseBox:SetHeight(houseHeight)
                houseBox:SetHidden(false)
                houseY = houseY + houseHeight + C.CATEGORY_ASSIGNMENT_HOUSE_SPACING
            end
        end
        control.houseScrollContents:SetDimensions(C.CATEGORY_ASSIGNMENT_SCROLL_CONTENTS_WIDTH, houseY)

        if not control.categoryTags then
            control.categoryTags = {}
        end
        local categories = MAGIC_SORTER:GetFurnitureCategories()
        for categoryId, category in pairs(categories) do
            local categoryTag = control.categoryTags[categoryId]
            if not categoryTag then
                categoryTag = control:CreateCategoryTag(category)
            end
            local assignments = MAGIC_SORTER:GetCategoryHouseAssignments(categoryId)
            local numAssignments = #assignments
            local tooltip
            categoryTag:GetNamedChild("AssignmentsLabel"):SetText(numAssignments == C.SCROLL_SLIDER_ZERO_THRESHOLD and "" or string.format("%d house%s", numAssignments, C.VERTEX_INDEX_1 == numAssignments and "" or "s"))
            if numAssignments > C.SCROLL_SLIDER_ZERO_THRESHOLD then
                table.sort(assignments, HouseNameComparer)
                tooltip = string.format("Assigned House%s:|cffffff", numAssignments == C.VERTEX_INDEX_1 and "" or "s")
                for index, house in ipairs(assignments) do
                    tooltip = string.format("%s\n%s", tooltip, house.houseName)
                end
            end
            categoryTag.tooltip = tooltip
        end
        local sortedTags = {}
        for _, categoryTag in pairs(control.categoryTags) do
            table.insert(sortedTags, categoryTag)
        end
        table.sort(sortedTags, function (tagA, tagB) return tagB.category.displayName > tagA.category.displayName end)
        tagY = C.CATEGORY_ASSIGNMENT_CATEGORY_START_Y
        for tagIndex, categoryTag in ipairs(sortedTags) do
            local offsetX, width
            if categoryTag.category.parentId == C.SCROLL_SLIDER_ZERO_THRESHOLD then
                offsetX, width = C.SCROLL_SLIDER_ZERO_THRESHOLD, C.CATEGORY_ASSIGNMENT_CATEGORY_PARENT_WIDTH
            else
                offsetX, width = C.CATEGORY_ASSIGNMENT_CATEGORY_CHILD_OFFSET_X, C.CATEGORY_ASSIGNMENT_CATEGORY_CHILD_WIDTH
            end
            categoryTag:ClearAnchors()
            categoryTag:SetAnchor(TOPLEFT, control.categoryScrollContents, TOPLEFT, offsetX, tagY)
            categoryTag:SetDimensions(width, C.CATEGORY_ASSIGNMENT_CATEGORY_HEIGHT)
            categoryTag.originalX = offsetX
            categoryTag.originalY = tagY
            tagY = tagY + C.CATEGORY_ASSIGNMENT_CATEGORY_SPACING
        end
        control.categoryScrollContents:SetDimensions(C.CATEGORY_ASSIGNMENT_SCROLL_CONTENTS_WIDTH, tagY)

        control:RefreshScrollSlider()
    end
    control.Submit = function ()
        return MAGIC_SORTER:OnSubmitCategoryAssignments()
    end
    control.backdropAnimation = animationManager:CreateTimelineFromVirtual("MagicSorter_TopLevelBackdropAnimation", control)
    if not control:IsHidden() then
        control.backdropAnimation:PlayFromStart()
    end
end

---@param control MagicSorter_CategoryAssignment
---@param hidden boolean
function MagicSorterDialogs.CategoryAssignment_OnEffectivelyShown(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:PlayFromStart()
    end
end

---@param control MagicSorter_CategoryAssignment
---@param hidden boolean
function MagicSorterDialogs.CategoryAssignment_OnEffectivelyHidden(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:Stop()
    end
end

---@param control MagicSorter_CategoryAssignment
function MagicSorterDialogs.CategoryAssignment_OnResizeStop(control)
    MAGIC_SORTER:OnDialogMoved(control)
    control:Refresh()
end

---@param control ScrollControl
function MagicSorterDialogs.CategoryScrollPanel_OnInitialized(control)
    control:GetOwningWindow().categoryScrollPanel = control
end

---@param control ScrollControl
---@param delta number
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.CategoryScrollPanel_OnMouseWheel(control, delta, ctrl, alt, shift, command)
    local slider = control:GetOwningWindow().categoryScrollSlider
    local value = slider:GetValue()
    if value == C.SCROLL_SLIDER_ZERO_THRESHOLD then
        value = C.SCROLL_SLIDER_ZERO_REPLACEMENT
    end
    slider:SetValue(value - (delta * C.CATEGORY_ASSIGNMENT_SCROLL_MULTIPLIER))
end

---@param control Control
function MagicSorterDialogs.CategoryScrollContents_OnInitialized(control)
    control:GetOwningWindow().categoryScrollContents = control
end

---@param control SliderControl
function MagicSorterDialogs.CategoryScrollSlider_OnInitialized(control)
    control:GetOwningWindow().categoryScrollSlider = control
    control:SetValue(C.SCROLL_SLIDER_DEFAULT_VALUE)
end

---@param control SliderControl
---@param value number
---@param eventReason number
function MagicSorterDialogs.CategoryScrollSlider_OnValueChanged(control, value, eventReason)
    control:GetOwningWindow().categoryScrollPanel:SetVerticalScroll(value)
end

---@param control ScrollControl
function MagicSorterDialogs.HouseScrollPanel_OnInitialized(control)
    control:GetOwningWindow().houseScrollPanel = control
end

---@param control ScrollControl
---@param delta number
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.HouseScrollPanel_OnMouseWheel(control, delta, ctrl, alt, shift, command)
    local slider = control:GetOwningWindow().houseScrollSlider
    local value = slider:GetValue()
    if value == C.SCROLL_SLIDER_ZERO_THRESHOLD then
        value = C.SCROLL_SLIDER_ZERO_REPLACEMENT
    end
    slider:SetValue(value - (delta * C.CATEGORY_ASSIGNMENT_SCROLL_MULTIPLIER))
end

---@param control Control
function MagicSorterDialogs.HouseScrollContents_OnInitialized(control)
    control:GetOwningWindow().houseScrollContents = control
end

---@param control SliderControl
function MagicSorterDialogs.HouseScrollSlider_OnInitialized(control)
    control:GetOwningWindow().houseScrollSlider = control
    control:SetValue(C.SCROLL_SLIDER_DEFAULT_VALUE)
end

---@param control SliderControl
---@param value number
---@param eventReason number
function MagicSorterDialogs.HouseScrollSlider_OnValueChanged(control, value, eventReason)
    control:GetOwningWindow().houseScrollPanel:SetVerticalScroll(value)
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.CategoryAssignmentBackButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    MAGIC_SORTER:SetDialogHidden("CategoryAssignment", true)
    MAGIC_SORTER:SetDialogHidden("HouseSelection", false)
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.CategoryAssignmentNextButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    if control:GetOwningWindow():Submit() then
        MAGIC_SORTER:SetDialogHidden("CategoryAssignment", true)
        MAGIC_SORTER:SetDialogHidden("Disclaimer", false)
    end
end

-- Theme Assignment Dialog
---@param control MagicSorter_ThemeAssignment
function MagicSorterDialogs.ThemeAssignment_OnInitialized(control)
    local buttonWidth = C.THEME_ASSIGNMENT_BUTTON_WIDTH
    local buttonHeight = C.THEME_ASSIGNMENT_BUTTON_HEIGHT
    local topLevel = control
    control.subtitle = control:GetNamedChild("BodySubtitleLabel")
    control.optionButtons = {}
    local function OnSelectionChanged(controlItem)
        topLevel:Submit(controlItem)
        topLevel:Refresh()
    end
    control.GetHouse = function ()
        local house = MAGIC_SORTER:GetStorageHouse(control.house.houseId)
        house.assignedThemeIds = house.assignedThemeIds or {}
        return house
    end
    control.SetHouse = function (self, house)
        self.house = house
    end
    control.GetNumColumns = function ()
        local width = control.scrollPanel:GetWidth()
        local columns = zo_max(C.VERTEX_INDEX_1, zo_floor((width - C.THEME_ASSIGNMENT_SCROLL_PADDING) / buttonWidth))
        return columns
    end
    control.GetOptionButtonPosition = function (self, optionIndex)
        local columns = self:GetNumColumns()
        local x = C.THEME_ASSIGNMENT_SCROLL_PADDING + ((optionIndex - C.VERTEX_INDEX_1) % columns) * buttonWidth
        local y = C.THEME_ASSIGNMENT_SCROLL_PADDING + zo_floor((optionIndex - C.VERTEX_INDEX_1) / columns) * buttonHeight
        return x, y
    end
    control.CreateOptionButton = function ()
        local optionIndex = #control.optionButtons + C.VERTEX_INDEX_1
        local optionButton = windowManager:CreateControlFromVirtual("ThemeOptionButton", control.scrollContents, "MagicSorter_Toggle", optionIndex)
        optionButton:ClearAnchors()
        optionButton:SetDimensions(buttonWidth - C.THEME_ASSIGNMENT_BUTTON_PADDING, buttonHeight - C.THEME_ASSIGNMENT_BUTTON_PADDING)
        optionButton.onToggled = OnSelectionChanged
        control.optionButtons[optionIndex] = optionButton
        local x, y = control:GetOptionButtonPosition(optionIndex)
        optionButton:SetAnchor(TOPLEFT, control.scrollContents, TOPLEFT, x, y)
        return optionButton
    end
    control.RefreshCount = function ()
        local house = control:GetHouse()
        local themes = house.assignedThemeIds
        local countString = "All"
        local count = NonContiguousCount(themes)
        if themes and count > C.SCROLL_SLIDER_ZERO_THRESHOLD then
            countString = tostring(count)
        end
        control.countLabel:SetText(string.format("%s selected", countString))
    end
    control.Refresh = function ()
        local themes = MAGIC_SORTER:GetSortManager().FurnitureThemeList
        local house = control:GetHouse()
        local assigned = house.assignedThemeIds
        local allSelected = NonContiguousCount(assigned) == C.SCROLL_SLIDER_ZERO_THRESHOLD
        control.subtitle:SetText(house.houseName)
        if #control.optionButtons == C.SCROLL_SLIDER_ZERO_THRESHOLD then
            for _, theme in ipairs(themes) do
                local optionButton = control:CreateOptionButton()
                optionButton.theme = theme
                optionButton:SetLabel(theme.name)
                optionButton:SetHidden(false)
            end
        end
        for _, optionButton in ipairs(control.optionButtons) do
            local theme = optionButton.theme
            local selected
            if theme.id == C.SCROLL_SLIDER_ZERO_THRESHOLD then
                selected = allSelected
            else
                selected = true == assigned[theme.id] and not allSelected
            end
            optionButton:Toggle(selected)
        end
        local columns = control:GetNumColumns()
        local maxY = zo_floor(#themes / columns) * buttonHeight
        control.scrollSlider:SetMinMax(C.SCROLL_SLIDER_MIN_VALUE, maxY)
        control:RefreshCount()
    end
    control.GetSelectedThemes = function ()
        local themes = {}
        for _, optionButton in ipairs(control.optionButtons) do
            if optionButton:IsSelected() then
                if optionButton.theme.id == C.SCROLL_SLIDER_ZERO_THRESHOLD then
                    themes = {}
                    break
                else
                    themes[optionButton.theme.id] = true
                end
            else
                themes[optionButton.theme.id] = nil
            end
        end
        return themes
    end
    control.Submit = function (self, optionButton)
        local house = self:GetHouse()
        if optionButton then
            local selected = optionButton:IsSelected()
            local themeId = optionButton.theme.id
            if themeId == 0 and selected then
                for _, optionButtonItem in ipairs(self.optionButtons) do
                    if optionButtonItem.theme.id ~= 0 then
                        optionButtonItem:Toggle(false)
                    end
                end
            elseif themeId ~= 0 and selected then
                for _, optionButtonItem in ipairs(self.optionButtons) do
                    if optionButtonItem.theme.id == 0 then
                        optionButtonItem:Toggle(false)
                    end
                end
            end
        end
        house.assignedThemeIds = self:GetSelectedThemes()
        MAGIC_SORTER:OnSettingsChanged()
        return true
    end
    control.backdropAnimation = animationManager:CreateTimelineFromVirtual("MagicSorter_TopLevelBackdropAnimation", control)
    if not control:IsHidden() then
        control.backdropAnimation:PlayFromStart()
    end
end

---@param control MagicSorter_ThemeAssignment
---@param hidden boolean
function MagicSorterDialogs.ThemeAssignment_OnEffectivelyShown(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:PlayFromStart()
    end
    control:Refresh()
end

---@param control MagicSorter_ThemeAssignment
---@param hidden boolean
function MagicSorterDialogs.ThemeAssignment_OnEffectivelyHidden(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:Stop()
    end
end

---@param control MagicSorter_ThemeAssignment
function MagicSorterDialogs.ThemeAssignment_OnResizeStop(control)
    MAGIC_SORTER:OnDialogMoved(control)
    control:Refresh()
end

---@param control ScrollControl
function MagicSorterDialogs.ThemeScrollPanel_OnInitialized(control)
    control:GetOwningWindow().scrollPanel = control
end

---@param control ScrollControl
---@param delta number
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.ThemeScrollPanel_OnMouseWheel(control, delta, ctrl, alt, shift, command)
    local slider = control:GetOwningWindow().scrollSlider
    local value = slider:GetValue()
    if value == C.SCROLL_SLIDER_ZERO_THRESHOLD then
        value = C.SCROLL_SLIDER_ZERO_REPLACEMENT
    end
    slider:SetValue(value - (delta * C.THEME_ASSIGNMENT_SCROLL_MULTIPLIER))
end

---@param control Control
function MagicSorterDialogs.ThemeScrollContents_OnInitialized(control)
    control:GetOwningWindow().scrollContents = control
end

---@param control SliderControl
function MagicSorterDialogs.ThemeScrollSlider_OnInitialized(control)
    control:GetOwningWindow().scrollSlider = control
    control:SetValue(C.SCROLL_SLIDER_DEFAULT_VALUE)
end

---@param control SliderControl
---@param value number
---@param eventReason number
function MagicSorterDialogs.ThemeScrollSlider_OnValueChanged(control, value, eventReason)
    control:GetOwningWindow().scrollPanel:SetVerticalScroll(value)
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.ThemeAssignmentSaveButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    MAGIC_SORTER:SetDialogHidden("ThemeAssignment", true)
    MAGIC_SORTER:SetDialogHidden("CategoryAssignment", false)
end

---@param control MagicSorter_CenterLabel
function MagicSorterDialogs.ThemeAssignmentCountLabel_OnInitialized(control)
    control:GetOwningWindow().countLabel = control:GetNamedChild("Label")
end

-- Disclaimer Dialog
---@param control MagicSorter_Disclaimer
function MagicSorterDialogs.Disclaimer_OnInitialized(control)
    control.backdropAnimation = animationManager:CreateTimelineFromVirtual("MagicSorter_TopLevelBackdropAnimation", control)
    if not control:IsHidden() then
        control.backdropAnimation:PlayFromStart()
    end
    local body = control:GetNamedChild("Body")
    body:GetNamedChild("StartQuickSort").tooltip = "Sorts your storage homes using Magic Sorter's furniture tracking " ..
        "data in order to avoid visits to homes that are already sorted. " ..
        "Note that a full scan will be required if you have changed any sort options.\n\n" ..
        "Only use this option if you have the Magic Sorter add-on enabled for all of your characters; " ..
        "otherwise, Magic Sorter's furniture tracking data may not be accurate."
    body:GetNamedChild("StartFullSort").tooltip = "Performs a thorough sort of all of your storage homes."
end

---@param control MagicSorter_Disclaimer
---@param hidden boolean
function MagicSorterDialogs.Disclaimer_OnEffectivelyShown(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:PlayFromStart()
    end
    zo_callLater(function () MAGIC_SORTER:SetUIMode(true) end, C.DISCLAIMER_UI_MODE_DELAY_MS)
end

---@param control MagicSorter_Disclaimer
---@param hidden boolean
function MagicSorterDialogs.Disclaimer_OnEffectivelyHidden(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:Stop()
    end
end

---@param control MagicSorter_OptionButton
---@param hidden boolean
function MagicSorterDialogs.DisclaimerManageLayout_OnEffectivelyShown(control, hidden)
    control.onToggled = function (self)
        if MAGIC_SORTER then
            MAGIC_SORTER:SetOrganizationEnabled(self:IsSelected())
        end
    end
    local icon = control:GetNamedChild("Icon")
    icon:SetTexture("MagicSorter/media/button-stack-furniture.dds")
    icon:SetDimensions(116, 116)
    local label = control:GetNamedChild("Label")
    label:SetFont("$(GAMEPAD_MEDIUM_FONT)|$(GP_20)")
    label:SetText("Organize Furniture")
    control:Toggle(MAGIC_SORTER:IsOrganizationEnabled())
end

---@param control Control
function MagicSorterDialogs.DisclaimerManageLayout_OnMouseEnter(control)
    ZO_Tooltips_ShowTextTooltip(control, RIGHT, "When this option is enabled your stored furnishings will automatically be placed neatly in stacks.\n\n" ..
        "Disable this option if you would prefer to organize your stored furnishings manually; when this option is disabled all furnishings will " ..
        "be placed in a single stack.")
end

---@param control Control
function MagicSorterDialogs.DisclaimerManageLayout_OnMouseExit(control)
    ZO_Tooltips_HideTextTooltip()
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.DisclaimerBackButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    MAGIC_SORTER:SetDialogHidden("Disclaimer", true)
    MAGIC_SORTER:SetDialogHidden("CategoryAssignment", false)
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.DisclaimerStartQuickSort_OnMouseDown(control, button, ctrl, alt, shift, command)
    MAGIC_SORTER:SetQuickSortMode(true)
    MAGIC_SORTER:SetDialogHidden("Disclaimer", true)
    MAGIC_SORTER:SetDialogHidden("StorageProgress", false)
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.DisclaimerStartFullSort_OnMouseDown(control, button, ctrl, alt, shift, command)
    MAGIC_SORTER:SetQuickSortMode(false)
    MAGIC_SORTER:SetDialogHidden("Disclaimer", true)
    MAGIC_SORTER:SetDialogHidden("StorageProgress", false)
end

-- Storage Progress Dialog
---@param control MagicSorter_StorageProgress
function MagicSorterDialogs.StorageProgress_OnInitialized(control)
    control.statusDetailRows = {}
    control.Refresh = function ()
        control.isActive = true
        control.suspendButton = control:GetNamedChild("Body"):GetNamedChild("SuspendButton")
        control.suspendButtonLabel = control.suspendButton:GetNamedChild("Label")
        control.cancelButton = control:GetNamedChild("Body"):GetNamedChild("CancelButton")
        control.showDetailsButton = control:GetNamedChild("Body"):GetNamedChild("ShowDetailsButton")
        control.hideDetailsButton = control:GetNamedChild("Body"):GetNamedChild("HideDetailsButton")
        MAGIC_SORTER:StartAutomaticStorage()
        control:RefreshStatus()
    end
    control.RefreshStatus = function ()
        control.statusLabel:SetText(control.message)
        control.suspendButtonLabel:SetText(control.isActive and "Suspend" or "Resume")
        control.activeWarning:SetHidden(not control.isActive)
        eventManager:RegisterForUpdate(MAGIC_SORTER.EventDescriptor .. "RefreshStatusDetail", C.STORAGE_PROGRESS_REFRESH_INTERVAL_MS, MagicSorter_StorageProgressDetail.RefreshStatusDetail)
    end
    control.SetMessage = function (self, message)
        self.message = message
        self:RefreshStatus()
    end
    control.SetState = function (self, isActive)
        self.isActive = isActive
        self:RefreshStatus()
    end
    control.SetComplete = function (self, isComplete)
        if isComplete then
            MAGIC_SORTER:SetDialogHidden("StorageProgress", true)
            MAGIC_SORTER:SetDialogHidden("Complete", false)
            eventManager:RegisterForUpdate(MAGIC_SORTER.EventDescriptor .. "AutoReload", C.STORAGE_PROGRESS_AUTO_RELOAD_INTERVAL_MS, function ()
                eventManager:UnregisterForUpdate(MAGIC_SORTER.EventDescriptor .. "AutoReload")
                MAGIC_SORTER:GetData().showCompleteDialog = true
                ReloadUI("ingame")
            end)
        end
    end
    control.OnExpandCollapseDetails = function ()
        control.detailsCollapsed = not control.detailsCollapsed
        MagicSorter_StorageProgressDetail:SetHidden(control.detailsCollapsed)
        if control.showDetailsButton then
            control.showDetailsButton:SetHidden(not control.detailsCollapsed)
            control.hideDetailsButton:SetHidden(control.detailsCollapsed)
        end
    end
    control.backdropAnimation = animationManager:CreateTimelineFromVirtual("MagicSorter_TopLevelBackdropAnimation", control)
    if not control:IsHidden() then
        control.backdropAnimation:PlayFromStart()
    end
end

---@param control MagicSorter_StorageProgress
---@param hidden boolean
function MagicSorterDialogs.StorageProgress_OnEffectivelyShown(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:PlayFromStart()
    end
    if not control.detailsCollapsed then
        MagicSorter_StorageProgressDetail:SetHidden(false)
    end
end

---@param control MagicSorter_StorageProgress
---@param hidden boolean
function MagicSorterDialogs.StorageProgress_OnEffectivelyHidden(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:Stop()
    end
    MagicSorter_StorageProgressDetail:SetHidden(true)
end

---@param control MagicSorter_CenterSubtitle
function MagicSorterDialogs.StorageProgressStatus_OnInitialized(control)
    local label = control:GetNamedChild("Label")
    label:SetMaxLineCount(2)
    control:GetOwningWindow().statusLabelBox = control
    control:GetOwningWindow().statusLabel = label
end

---@param control LabelControl
function MagicSorterDialogs.StorageProgressActiveWarning_OnInitialized(control)
    control:GetOwningWindow().activeWarning = control
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.StorageProgressSuspendButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    if MAGIC_SORTER:IsAutomaticStorageRunning() then
        MAGIC_SORTER:SuspendAutomaticStorage()
    else
        MAGIC_SORTER:ResumeAutomaticStorage()
    end
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.StorageProgressCancelButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    if MAGIC_SORTER:IsAutomaticStorageRunning() then
        MAGIC_SORTER:CancelAutomaticStorage()
    end
    MAGIC_SORTER:SetDialogHidden("StorageProgress", true)
end

---@param control LabelControl
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.StorageProgressShowDetailsButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    control:GetOwningWindow():OnExpandCollapseDetails()
end

---@param control LabelControl
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.StorageProgressHideDetailsButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    control:GetOwningWindow():OnExpandCollapseDetails()
end

-- Storage Progress Detail Dialog
---@param control MagicSorter_StorageProgressDetail
function MagicSorterDialogs.StorageProgressDetail_OnInitialized(control)
    control.previousHouseIndex = nil
    control.statusDetailRows = {}
    control.actionLogScrollContainer = control:GetNamedChild("LogScrollContainer")
    control.actionLogScrollSlider = control.actionLogScrollContainer:GetNamedChild("LogScrollSlider")
    control.detailScrollContainer = control:GetNamedChild("DetailScrollContainer")
    control.detailPanel = control:GetNamedChild("DetailScrollContainer"):GetNamedChild("DetailScrollPanel")
    control.detailScrollContents = control.detailPanel:GetNamedChild("DetailScrollContents")
    control.detailScrollSlider = control:GetNamedChild("DetailScrollContainer"):GetNamedChild("DetailScrollSlider")
    local detailTabButton = control:GetNamedChild("DetailTabButton")
    local logTabButton = control:GetNamedChild("LogTabButton")
    local myself = control
    detailTabButton.onMouseDown = function (self)
        detailTabButton:SetActive()
        logTabButton:SetInactive()
        myself.actionLogScrollContainer:SetHidden(true)
        myself.detailScrollContainer:SetHidden(false)
    end
    logTabButton.onMouseDown = function (self)
        detailTabButton:SetInactive()
        logTabButton:SetActive()
        myself.actionLogScrollContainer:SetHidden(false)
        myself.detailScrollContainer:SetHidden(true)
    end
    detailTabButton:SetActive()
    local headerRow = control:GetNamedChild("DetailScrollContainer"):GetNamedChild("HeaderRow")
    control.headerRow = headerRow
    headerRow:SetHouse(-1, "Storage House")
    headerRow:SetCapacity("Traditional/\nSpecial Slots")
    headerRow:SetStatus("Pending Items\nOutbound/Inbound")
    headerRow:SetHeaderRow()
    ---@diagnostic disable-next-line: missing-parameter
    headerRow:SetAnchor(TOPLEFT)
    headerRow:SetHidden(false)
    control.RefreshStatusDetail = function ()
        eventManager:UnregisterForUpdate(MAGIC_SORTER.EventDescriptor .. "RefreshStatusDetail")
        if control.detailPanel:IsHidden() then
            return
        end
        local houses = {}
        local sortManager = MAGIC_SORTER:GetSortManager()
        for _, house in pairs(MAGIC_SORTER:GetStorageHouses()) do
            local houseId = house.houseId
            local removables = sortManager:GetHouseRemovables(houseId)
            local removableCount = removables and #removables or nil
            local placeables = sortManager:GetPlaceableFurnitureListForHouse(houseId)
            local placeableCount = 0
            if placeables then
                for _, placeable in ipairs(placeables) do
                    placeableCount = placeableCount + (placeable.stackSize or 1)
                end
            end
            local status = { houseId = houseId, houseName = house.houseName, placeable = placeableCount, removable = removableCount }
            table.insert(houses, status)
        end
        table.sort(houses, function (houseA, houseB) return houseB.houseName > houseA.houseName end)
        local currentHouseId = GetCurrentZoneHouseId()
        local currentHouseIndex
        for index = 1, #houses do
            if houses[index].houseId == currentHouseId then
                currentHouseIndex = index
                break
            end
        end
        local previousRow
        local maxIndex = 0
        for index, house in ipairs(houses) do
            local controlItem = control.statusDetailRows[index]
            if not controlItem then
                controlItem = WINDOW_MANAGER:CreateControlFromVirtual("MagicSorter_StorageProgressStatusDetailRow", control.detailScrollContents, "MagicSorter_StatusDetailRow", index)
                if previousRow then
                    controlItem:SetAnchor(TOPLEFT, previousRow, BOTTOMLEFT)
                else
                    controlItem:SetAnchor(TOPLEFT, previousRow, TOPLEFT)
                end
                control.statusDetailRows[index] = controlItem
            end
            controlItem:SetHouse(house.houseId, house.houseName)
            local capacityTraditional = sortManager:GetHouseCapacity(house.houseId, HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_ITEM)
            local capacitySpecial = sortManager:GetHouseCapacity(house.houseId, HOUSING_FURNISHING_LIMIT_TYPE_HIGH_IMPACT_ITEM)
            if capacityTraditional and capacitySpecial then
                controlItem:SetCapacity(string.format("%d/%d available", capacityTraditional, capacitySpecial))
            else
                controlItem:SetCapacity("-/-")
            end
            if house.removable and house.placeable then
                local placeableColor = house.placeable ~= 0 and "|c99ffff" or "|cdddddd"
                local removableColor = house.removable ~= 0 and "|c99ffff" or "|cdddddd"
                controlItem:SetStatus(string.format("%s%d|cffffff item%s/%s%d|cffffff item%s", removableColor, house.removable, house.removable == 1 and "" or "s", placeableColor, house.placeable, house.placeable == 1 and "" or "s"))
            else
                controlItem:SetStatus("Assessing")
            end
            controlItem:SetComplete(house.removable and house.removable == 0 and house.placeable and house.placeable == 0)
            controlItem:SetHidden(false)
            previousRow = controlItem
            maxIndex = index
        end
        local height = C.STORAGE_PROGRESS_DETAIL_START_HEIGHT + maxIndex * C.STORAGE_PROGRESS_DETAIL_ROW_HEIGHT
        control.detailScrollContents:SetDimensions(C.STORAGE_PROGRESS_DETAIL_SCROLL_CONTENTS_WIDTH, height)
        control.detailScrollSlider:SetMinMax(C.SCROLL_SLIDER_MIN_VALUE, height)
        for index = maxIndex + C.VERTEX_INDEX_1, #control.statusDetailRows do
            control.statusDetailRows[index]:SetHidden(true)
        end
        if currentHouseIndex and currentHouseIndex ~= control.previousHouseIndex then
            control.detailScrollSlider:SetValue(zo_max(C.SCROLL_SLIDER_MIN_VALUE, C.STORAGE_PROGRESS_DETAIL_ROW_HEIGHT * (currentHouseIndex - C.VERTEX_INDEX_2)))
            control.previousHouseIndex = currentHouseIndex
        end
    end
    control.RefreshActionLog = function (self)
        local actions = MAGIC_SORTER:GetSortManager():GetActionLog()
        if actions and #actions ~= C.SCROLL_SLIDER_ZERO_THRESHOLD then
            local slider = self.actionLogScrollSlider
            local panel = self:GetNamedChild("LogScrollContainerLogScrollPanel")
            local logContainer = self:GetNamedChild("LogScrollContainerLogScrollPanelLogScrollContents")
            local logControl = self:GetNamedChild("LogScrollContainerLogScrollPanelLogScrollContentsActionLog")
            logControl:SetText(table.concat(actions, "\n"))
            zo_callLater(function ()
                             local height = logControl:GetTextHeight()
                             logContainer:SetDimensions(C.ACTION_LOG_SCROLL_CONTENTS_WIDTH, height)
                             height = height - panel:GetHeight()
                             height = zo_max(C.SCROLL_SLIDER_MIN_VALUE, height)
                             slider:SetMinMax(C.SCROLL_SLIDER_MIN_VALUE, height)
                         end, C.ACTION_LOG_REFRESH_DELAY_MS)
        end
    end
end

---@param control ScrollControl
---@param delta number
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.DetailScrollPanel_OnMouseWheel(control, delta, ctrl, alt, shift, command)
    local slider = control:GetParent():GetNamedChild("DetailScrollSlider")
    local value = slider:GetValue()
    if value == C.SCROLL_SLIDER_ZERO_THRESHOLD then
        value = C.SCROLL_SLIDER_ZERO_REPLACEMENT
    end
    slider:SetValue(value - (delta * C.STORAGE_PROGRESS_DETAIL_SCROLL_MULTIPLIER))
end

---@param control SliderControl
---@param value number
---@param eventReason number
function MagicSorterDialogs.DetailScrollSlider_OnValueChanged(control, value, eventReason)
    control:GetParent():GetNamedChild("DetailScrollPanel"):SetVerticalScroll(value)
end

---@param control ScrollControl
---@param delta number
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.LogScrollPanel_OnMouseWheel(control, delta, ctrl, alt, shift, command)
    local slider = control:GetParent():GetNamedChild("LogScrollSlider")
    local value = slider:GetValue()
    if value == C.SCROLL_SLIDER_ZERO_THRESHOLD then
        value = C.SCROLL_SLIDER_ZERO_REPLACEMENT
    end
    slider:SetValue(value - (delta * C.STORAGE_PROGRESS_DETAIL_SCROLL_MULTIPLIER))
end

---@param control SliderControl
---@param value number
---@param eventReason number
function MagicSorterDialogs.LogScrollSlider_OnValueChanged(control, value, eventReason)
    control:GetParent():GetNamedChild("LogScrollPanel"):SetVerticalScroll(value)
end

-- Complete Dialog
---@param control MagicSorter_Complete
function MagicSorterDialogs.Complete_OnInitialized(control)
    control.backdropAnimation = animationManager:CreateTimelineFromVirtual("MagicSorter_TopLevelBackdropAnimation", control)
    if not control:IsHidden() then
        control.backdropAnimation:PlayFromStart()
    end
    control.Refresh = function (self)
        local report = MAGIC_SORTER:GetSortManager():GetLastReport()
        local slider = self:GetNamedChild("ScrollContainerScrollSlider")
        local panel = self:GetNamedChild("ScrollContainerScrollPanel")
        local container = self:GetNamedChild("ScrollContainerScrollPanelScrollContents")
        local controlItem = self:GetNamedChild("ScrollContainerScrollPanelScrollContentsMessage")
        local reportText = table.concat(report or {}, "\n")
        controlItem:SetText(reportText)
        zo_callLater(function ()
                         local height = controlItem:GetTextHeight()
                         container:SetDimensions(C.COMPLETE_DIALOG_SCROLL_CONTENTS_WIDTH, height)
                         height = zo_max(C.SCROLL_SLIDER_MIN_VALUE, height - panel:GetHeight())
                         slider:SetMinMax(C.SCROLL_SLIDER_MIN_VALUE, height)
                     end, C.COMPLETE_DIALOG_REFRESH_DELAY_MS)
    end
end

---@param control MagicSorter_Complete
---@param hidden boolean
function MagicSorterDialogs.Complete_OnEffectivelyShown(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:PlayFromStart()
    end
    control:Refresh()
end

---@param control MagicSorter_Complete
---@param hidden boolean
function MagicSorterDialogs.Complete_OnEffectivelyHidden(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:Stop()
    end
end

---@param control ScrollControl
---@param delta number
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.CompleteScrollPanel_OnMouseWheel(control, delta, ctrl, alt, shift, command)
    local slider = control:GetParent():GetNamedChild("ScrollSlider")
    local value = slider:GetValue()
    if value == C.SCROLL_SLIDER_ZERO_THRESHOLD then
        value = C.SCROLL_SLIDER_ZERO_REPLACEMENT
    end
    slider:SetValue(value - (delta * C.COMPLETE_DIALOG_SCROLL_MULTIPLIER))
end

---@param control SliderControl
---@param value number
---@param eventReason number
function MagicSorterDialogs.CompleteScrollSlider_OnValueChanged(control, value, eventReason)
    control:GetParent():GetNamedChild("ScrollPanel"):SetVerticalScroll(value)
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.CompleteCloseButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    eventManager:UnregisterForUpdate(MAGIC_SORTER.EventDescriptor .. "AutoReload")
    MAGIC_SORTER:SetDialogHidden("Complete", true)
    MAGIC_SORTER:GetData().showCompleteDialog = false
end

-- Report Summary Dialog
---@param control MagicSorter_ReportSummary
function MagicSorterDialogs.ReportSummary_OnInitialized(control)
    control.panel = control:GetNamedChild("ScrollContainerScrollPanel")
    control.slider = control:GetNamedChild("ScrollContainerScrollSlider")
    control.message = control.panel:GetNamedChild("ScrollContentsMessage")
    control.visibleHeight = C.REPORT_SUMMARY_VISIBLE_HEIGHT
    control:SetDimensions(C.REPORT_SUMMARY_WIDTH, control.visibleHeight)
    control.hideShowButton = control:GetNamedChild("HideShowButton")
    control.hideShowButton.nextState = "hide"
end

---@param control ScrollControl
---@param delta number
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.ReportSummaryScrollPanel_OnMouseWheel(control, delta, ctrl, alt, shift, command)
    local slider = control:GetParent():GetNamedChild("ScrollSlider")
    local value = slider:GetValue()
    if value == C.SCROLL_SLIDER_ZERO_THRESHOLD then
        value = C.SCROLL_SLIDER_ZERO_REPLACEMENT
    end
    slider:SetValue(value - (delta * C.REPORT_SUMMARY_SCROLL_MULTIPLIER))
end

---@param control SliderControl
---@param value number
---@param eventReason number
function MagicSorterDialogs.ReportSummaryScrollSlider_OnValueChanged(control, value, eventReason)
    control:GetParent():GetNamedChild("ScrollPanel"):SetVerticalScroll(value)
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.ReportSummaryHideShowButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    local window = control:GetOwningWindow()
    local scroll = window:GetNamedChild("ScrollContainer")
    local label = control:GetNamedChild("Label")
    local nextState = control.nextState or "hide"
    if nextState == "show" then
        control.nextState = "hide"
        label:SetText("Hide Report")
        scroll:SetHidden(false)
        window:SetHeight(window.visibleHeight)
    else
        control.nextState = "show"
        label:SetText("Show Report")
        scroll:SetHidden(true)
        window:SetHeight(0)
    end
end

-- Report Inventory Dialog
---@param control MagicSorter_ReportInventory
function MagicSorterDialogs.ReportInventory_OnInitialized(control)
    control.caption = control:GetNamedChild("Caption")
    control.panel = control:GetNamedChild("ScrollContainerScrollPanel")
    control.slider = control:GetNamedChild("ScrollContainerScrollSlider")
    control.contents = control.panel:GetNamedChild("ScrollContents")
    control.visibleHeight = C.REPORT_INVENTORY_VISIBLE_HEIGHT
    control:SetDimensions(C.REPORT_INVENTORY_WIDTH, control.visibleHeight)
    control.rowControlPool = ZO_ControlPool:New("MagicSorter_DataRow", control.contents)
    control.ShowReport = function (self, caption, rows)
        local columns = { C.REPORT_INVENTORY_COLUMN_WIDTH, C.REPORT_INVENTORY_COLUMN_WIDTH, C.REPORT_INVENTORY_COLUMN_WIDTH, C.REPORT_INVENTORY_COLUMN_WIDTH }
        self.caption:SetText(caption or "Report")
        self.rowControlPool:ReleaseAllObjects()
        if "table" == type(rows) then
            local predecessor
            for rowIndex, rowData in ipairs(rows) do
                local rowControl, key = self.rowControlPool:AcquireObject()
                rowControl.key = key
                rowControl:ClearAnchors()
                rowControl:SetupRow(nil, nil, columns)
                rowControl:UpdateColumns(rowData)
                if not predecessor then
                    rowControl:SetAnchor(TOPLEFT, self.contents, TOPLEFT)
                else
                    rowControl:SetAnchor(TOPLEFT, predecessor, BOTTOMLEFT)
                end
                rowControl:SetHidden(false)
                predecessor = rowControl
            end
        end
    end
end

---@param control ScrollControl
---@param delta number
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.ReportInventoryScrollPanel_OnMouseWheel(control, delta, ctrl, alt, shift, command)
    local slider = control:GetParent():GetNamedChild("ScrollSlider")
    local value = slider:GetValue()
    if value == C.SCROLL_SLIDER_ZERO_THRESHOLD then
        value = C.SCROLL_SLIDER_ZERO_REPLACEMENT
    end
    slider:SetValue(value - (delta * C.REPORT_INVENTORY_SCROLL_MULTIPLIER))
end

---@param control SliderControl
---@param value number
---@param eventReason number
function MagicSorterDialogs.ReportInventoryScrollSlider_OnValueChanged(control, value, eventReason)
    control:GetParent():GetNamedChild("ScrollPanel"):SetVerticalScroll(value)
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.ReportInventoryCloseButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    MAGIC_SORTER:SetDialogHidden("ReportInventory", true)
end
