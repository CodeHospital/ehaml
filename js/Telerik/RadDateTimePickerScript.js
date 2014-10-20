﻿Type.registerNamespace("Telerik.Web.UI");
$telerik.findDateTimePicker = $find;
$telerik.toDateTimePicker = function (a) {
    return a;
};
Telerik.Web.UI.RadDateTimePicker = function (a) {
    Telerik.Web.UI.RadDateTimePicker.initializeBase(this, [a]);
    this._timeView = null;
    this._timePopupButton = null;
    this._timePopupControlID = null;
    this._timePopupButtonSettings = null;
    this._onTimePopupImageMouseOverDelegate = null;
    this._onTimePopupImageMouseOutDelegate = null;
    this._onTimePopupImageClickDelegate = null;
    this._onTimePopupButtonKeyPressDelegate = null;
    this._onClientTimeSelectedDelegate = null;
    this._autoPostBackControl = Telerik.Web.UI.Calendar.AutoPostBackControl.None;
};
Telerik.Web.UI.RadDateTimePicker.TimePopupInstances = {};
Telerik.Web.UI.RadDateTimePicker.prototype = {
    initialize: function () {
        this._refreshTimePopupShadowSetting();
        Telerik.Web.UI.RadDateTimePicker.callBaseMethod(this, "initialize");
        this._timePopupContainerID = this.get_timeView().get_id() + "_wrapper";
    },
    dispose: function () {
        this.hideTimePopup();
        var b = this.get__timePopupImage();
        if (b != null) {
            if (this._onTimePopupImageMouseOverDelegate) {
                try {
                    $removeHandler(b, "mouseover", this._onTimePopupImageMouseOverDelegate);
                } catch (a) { }
                this._onTimePopupImageMouseOverDelegate = null;
            }
            if (this._onTimePopupImageMouseOutDelegate) {
                try {
                    $removeHandler(b, "mouseout", this._onTimePopupImageMouseOutDelegate);
                } catch (a) { }
                this._onTimePopupImageMouseOutDelegate = null;
            }
            if (this._onTimePopupImageClickDelegate) {
                try {
                    $removeHandler(this._timePopupButton, "click", this._onTimePopupImageClickDelegate);
                } catch (a) { }
                this._onTimePopupImageClickDelegate = null;
            }
        }
        if (this._onClientTimeSelectedDelegate) {
            this._timeView.remove_clientTimeSelected(this._onClientTimeSelectedDelegate);
            this._onClientTimeSelectedDelegate = null;
        }
        if (this._timeView != null) {
            this._timeView.dispose();
        }
        if (this._onTimePopupButtonKeyPressDelegate) {
            try {
                $removeHandler(this._timePopupButton, "keypress", this._onTimePopupButtonKeyPressDelegate);
            } catch (a) { }
            this._onTimePopupButtonKeyPressDelegate = null;
        }
        if (this._timePopupButton) {
            this._timePopupButton._events = null;
        }
        Telerik.Web.UI.RadDateTimePicker.callBaseMethod(this, "dispose");
    },
    set_enabled: function (b) {
        if (this._enabled != b) {
            var a = this.get__timePopupImage();
            if (b) {
                if (this._timePopupButton) {
                    Sys.UI.DomElement.removeCssClass(this._timePopupButton, "rcDisabled");
                    this._timePopupButton.setAttribute("href", "#");
                }
                if (this._onTimePopupImageClickDelegate) {
                    $addHandler(this._timePopupButton, "click", this._onTimePopupImageClickDelegate);
                } else {
                    if (this._timePopupButton) {
                        this._onTimePopupImageClickDelegate = Function.createDelegate(this, this._onTimePopupImageClickHandler);
                        $addHandler(this._timePopupButton, "click", this._onTimePopupImageClickDelegate);
                    }
                }
                if (this._onTimePopupImageMouseOverDelegate) {
                    $addHandler(a, "mouseover", this._onTimePopupImageMouseOverDelegate);
                }
                if (this._onTimePopupImageMouseOutDelegate) {
                    $addHandler(a, "mouseout", this._onTimePopupImageMouseOutDelegate);
                }
                if (this._onTimePopupButtonKeyPressDelegate) {
                    $addHandler(this._timePopupButton, "keypress", this._onTimePopupButtonKeyPressDelegate);
                }
            } else {
                this.hidePopup();
                this.hideTimePopup();
                if (this._onTimePopupImageClickDelegate) {
                    $removeHandler(this._timePopupButton, "click", this._onTimePopupImageClickDelegate);
                }
                if (this._onTimePopupImageMouseOverDelegate) {
                    $removeHandler(a, "mouseover", this._onTimePopupImageMouseOverDelegate);
                }
                if (this._onTimePopupImageMouseOutDelegate) {
                    $removeHandler(a, "mouseout", this._onTimePopupImageMouseOutDelegate);
                }
                if (this._onTimePopupButtonKeyPressDelegate) {
                    $removeHandler(this._timePopupButton, "keypress", this._onTimePopupButtonKeyPressDelegate);
                }
                if (this._timePopupButton) {
                    Sys.UI.DomElement.addCssClass(this._timePopupButton, "rcDisabled");
                    this._timePopupButton.removeAttribute("href");
                }
            }
            Telerik.Web.UI.RadDateTimePicker.callBaseMethod(this, "set_enabled", [b]);
        }
    },
    get_timeView: function () {
        if (this._timeView == null) {
            this._setUpTimeView();
        }
        return this._timeView;
    },
    get_timePopupContainer: function () {
        if (this._timePopupContainer == null) {
            this._timePopupContainer = $get(this._timePopupContainerID);
        }
        return this._timePopupContainer;
    },
    get_timePopupButton: function () {
        return this._timePopupButton;
    },
    GetTimePopupContainer: function () {
        return this.get_timePopupContainer();
    },
    toggleTimePopup: function () {
        if (this.isTimePopupVisible()) {
            this.hideTimePopup();
        } else {
            this.showTimePopup();
        }
        return false;
    },
    isTimePopupVisible: function () {
        return this.get__TimePopup().IsVisible() && (this.get__TimePopup().Opener == this);
    },
    showTimePopup: function (a, b) {
        this._setUpTimeView();
        if (this.isTimePopupVisible()) {
            return;
        }
        this._actionBeforeShowTimePopup();
        this.get__TimePopup().ExcludeFromHiding = this.get__TimePopupVisibleControls();
        this.hideTimePopup();
        var d = new Telerik.Web.UI.DatePickerPopupOpeningEventArgs(this.get_timeView(), false);
        this.raise_popupOpening(d);
        if (d.get_cancel() == true) {
            return;
        }
        if (this.get_dateInput().get_valueAsString()) {
            var c = this.get_dateInput().get_valueAsString().split("-");
            this.get_timeView()._selectTimeCell(parseInt(c[3], 10), parseInt(c[4], 10));
        } else {
            this.get_timeView()._clearSelection();
        }
        if (this._animationSettings.HideAnimationDuration > 0) {
            this.get_timeView()._clearHovers();
        }
        this.get__TimePopup().Opener = this;
        this.get__TimePopup().Show(a, b, this.get_timePopupContainer());
    },
    hideTimePopup: function () {
        if (!this.get_timeView()) {
            return false;
        }
        if (this.get__TimePopup().IsVisible()) {
            var a = this.get__TimePopup().Hide();
            if (a == false) {
                return false;
            }
        }
        return true;
    },
    get_timeView: function () {
        return this._timeView;
    },
    set_timeView: function (a) {
        this._timeView = a;
    },
    get_autoPostBackControl: function () {
        return this._autoPostBackControl;
    },
    set_autoPostBackControl: function (a) {
        this._autoPostBackControl = a;
    },
    get__TimePopupButtonSettings: function () {
        return this._timePopupButtonSettings;
    },
    set__TimePopupButtonSettings: function (a) {
        this._timePopupButtonSettings = a;
    },
    _setUpTimeView: function () {
        this._timeView.set__OwnerDatePickerID(this.get_id());
        this._onClientTimeSelectedDelegate = Function.createDelegate(this, this._onClientTimeSelectedHandler);
        this._timeView.add_clientTimeSelected(this._onClientTimeSelectedDelegate);
    },
    _onClientTimeSelectedHandler: function () {
        if (this.isTimePopupVisible()) {
            this._timeViewTimeSelected();
        }
    },
    get__timePopupImage: function () {
        var b = null;
        if (this._timePopupButton != null) {
            var a = this._timePopupButton.getElementsByTagName("img");
            if (a.length > 0) {
                b = a[0];
            } else {
                b = this._timePopupButton;
            }
        }
        return b;
    },
    _initializePopupButton: function () {
        Telerik.Web.UI.RadDateTimePicker.callBaseMethod(this, "_initializePopupButton");
        this._timePopupButton = $get(this._timePopupControlID);
        if (this._timePopupButton != null) {
            this._attachTimePopupButtonEvents();
        }
    },
    _attachTimePopupButtonEvents: function () {
        var a = this.get__timePopupImage();
        if (a != null) {
            if (!this._hasTimeAttribute("onmouseover")) {
                this._onTimePopupImageMouseOverDelegate = Function.createDelegate(this, this._onTimePopupImageMouseOverHandler);
                $addHandler(a, "mouseover", this._onTimePopupImageMouseOverDelegate);
            }
            if (!this._hasTimeAttribute("onmouseout")) {
                this._onTimePopupImageMouseOutDelegate = Function.createDelegate(this, this._onTimePopupImageMouseOutHandler);
                $addHandler(a, "mouseout", this._onTimePopupImageMouseOutDelegate);
            }
        }
        if (this._hasTimeAttribute("href") != null && this._hasTimeAttribute("href") != "" && this._hasTimeAttribute("onclick") == null) {
            this._onTimePopupImageClickDelegate = Function.createDelegate(this, this._onTimePopupImageClickHandler);
            $addHandler(this._timePopupButton, "click", this._onTimePopupImageClickDelegate);
        }
        if (this._timePopupButton) {
            this._onTimePopupButtonKeyPressDelegate = Function.createDelegate(this, this._onTimePopupButtonKeyPressHandler);
            $addHandler(this._timePopupButton, "keypress", this._onTimePopupButtonKeyPressDelegate);
        }
    },
    _onTimePopupImageMouseOverHandler: function () {
        this.get__timePopupImage().src = this._timePopupButtonSettings.ResolvedHoverImageUrl;
    },
    _onTimePopupImageMouseOutHandler: function () {
        this.get__timePopupImage().src = this._timePopupButtonSettings.ResolvedImageUrl;
    },
    _onTimePopupImageClickHandler: function (a) {
        this.toggleTimePopup();
        a.preventDefault();
        a.stopPropagation();
        return false;
    },
    _onTimePopupButtonKeyPressHandler: function (a) {
        if (a.charCode == 32) {
            this.toggleTimePopup();
            a.stopPropagation();
            a.preventDefault();
            return false;
        }
    },
    _onDateInputFocusHandler: function (a, b) {
        Telerik.Web.UI.RadDateTimePicker.callBaseMethod(this, "_onDateInputFocusHandler");
        if (!this._calendar && this.get_showPopupOnFocus()) {
            this.showTimePopup();
        }
    },
    _hasTimeAttribute: function (a) {
        return this._timePopupButton.getAttribute(a);
    },
    _refreshTimePopupShadowSetting: function () {
        if (!this.get_timeView()) {
            return;
        }
        var a = Telerik.Web.UI.RadDateTimePicker.TimePopupInstances[this.get_timeView().get_id()];
        if (a && !$telerik.quirksMode) {
            this.get__TimePopup().EnableShadows = this._enableShadows;
        }
        Telerik.Web.UI.RadDateTimePicker.callBaseMethod(this, "_refreshPopupShadowSetting");
    },
    get__TimePopup: function () {
        var a = Telerik.Web.UI.RadDateTimePicker.TimePopupInstances[this.get_timeView().get_id()];
        if (!a) {
            a = new Telerik.Web.UI.Calendar.Popup();
            if (this._zIndex) {
                a.zIndex = this._zIndex;
            }
            if (!this._enableShadows) {
                a.EnableShadows = false;
            }
            if (this._animationSettings) {
                a.ShowAnimationDuration = this._animationSettings.ShowAnimationDuration;
                a.ShowAnimationType = this._animationSettings.ShowAnimationType;
                a.HideAnimationDuration = this._animationSettings.HideAnimationDuration;
                a.HideAnimationType = this._animationSettings.HideAnimationType;
            }
            Telerik.Web.UI.RadDateTimePicker.TimePopupInstances[this.get_timeView().get_id()] = a;
        }
        return a;
    },
    get__TimePopupVisibleControls: function () {
        var a = [this.get_textBox(), this.get_popupContainer()];
        if (this._timePopupButton != null) {
            a[a.length] = this._timePopupButton;
        }
        return a;
    },
    _timeViewTimeSelected: function () {
        this.hideTimePopup();
    },
    _actionBeforeShowPopup: function () {
        Telerik.Web.UI.RadDateTimePicker.callBaseMethod(this, "_actionBeforeShowPopup");
        this._hideAllTimePopups();
    },
    _actionBeforeShowTimePopup: function () {
        Telerik.Web.UI.RadDateTimePicker.callBaseMethod(this, "_actionBeforeShowPopup");
        this._hideAllTimePopups();
    },
    _hideAllTimePopups: function () {
        for (var a in Telerik.Web.UI.RadDateTimePicker.TimePopupInstances) {
            if (Telerik.Web.UI.RadDateTimePicker.TimePopupInstances.hasOwnProperty(a)) {
                Telerik.Web.UI.RadDateTimePicker.TimePopupInstances[a].Hide();
            }
        }
    },
    _getJavaScriptDate: function (e) {
        var a = this._dateInput.get_selectedDate();
        var d = 0;
        var b = 0;
        var g = 0;
        var c = 0;
        if (a != null) {
            d = a.getHours();
            b = a.getMinutes();
            g = a.getSeconds();
            c = a.getMilliseconds();
        }
        var f = new Date(e[0], e[1] - 1, e[2], d, b, g, c);
        return f;
    },
    _setValidatorDate: function (e) {
        var b = "";
        if (e != null) {
            var c = (e.getMonth() + 1).toString();
            if (c.length == 1) {
                c = "0" + c;
            }
            var g = e.getDate().toString();
            if (g.length == 1) {
                g = "0" + g;
            }
            var a = e.getMinutes().toString();
            if (a.length == 1) {
                a = "0" + a;
            }
            var d = e.getHours().toString();
            if (d.length == 1) {
                d = "0" + d;
            }
            var f = e.getSeconds().toString();
            if (f.length == 1) {
                f = "0" + f;
            }
            b = e.getFullYear() + "-" + c + "-" + g + "-" + d + "-" + a + "-" + f;
        }
        this._validationInput.value = b;
    },
    _setInputDate: function (b) {
        if (this._autoPostBackControl == Telerik.Web.UI.Calendar.AutoPostBackControl.None || this._autoPostBackControl == Telerik.Web.UI.Calendar.AutoPostBackControl.TimeView) {
            var a = function (c, d) {
                d.set_cancel(true);
            };
            this._dateInput.add_valueChanged(a);
            Telerik.Web.UI.RadDateTimePicker.callBaseMethod(this, "_setInputDate", [b]);
            this._dateInput.remove_valueChanged(a);
        } else {
            Telerik.Web.UI.RadDateTimePicker.callBaseMethod(this, "_setInputDate", [b]);
        }
    }
};
Telerik.Web.UI.RadDateTimePicker.registerClass("Telerik.Web.UI.RadDateTimePicker", Telerik.Web.UI.RadDatePicker);