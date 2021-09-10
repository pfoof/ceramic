package elements;

import ceramic.Color;
import ceramic.Equal;
import ceramic.Pool;
import ceramic.View;
import tracker.Autorun.reobserve;
import tracker.Autorun.unobserve;

using StringTools;
using elements.WindowItem.WindowItemExtensions;

/**
 * A simple class to hold window item data.
 * The same class is used for every window item kind so
 * that it's easier to recycle it and avoid allocating
 * too much data at every frame.
 */
class WindowItem {

    static var pool = new Pool<WindowItem>();

    public static function get():WindowItem {

        var item = pool.get();
        if (item == null) {
            item = new WindowItem();
        }
        return item;

    }

    public var kind:WindowItemKind = UNKNOWN;

    public var previous:WindowItem = null;

    public var int0:Int = 0;

    public var int1:Int = 0;

    public var labelPosition:Int = 0;

    public var float0:Float = 0;

    public var float1:Float = 0;

    public var labelWidth:Float = 0;

    public var float3:Float = 0;

    public var float4:Float = 0;

    public var bool0:Bool = false;

    public var string0:String = null;

    public var string1:String = null;

    public var string2:String = null;

    public var string3:String = null;

    public var stringArray0:Array<String> = null;

    public function new() {}

    public function isSameItem(item:WindowItem):Bool {

        if (item == null)
            return false;

        if (item.kind != kind)
            return false;

        switch kind {

            case UNKNOWN:
                return false;

            case SELECT:
                if (isSimilarLabel(item) &&
                    (item.stringArray0 == stringArray0 || Equal.arrayEqual(item.stringArray0, stringArray0))) {
                    return true;
                }
                else {
                    return false;
                }

            case EDIT_TEXT:
                return isSimilarLabel(item);

            case EDIT_FLOAT:
                return isSimilarLabel(item);

            case EDIT_INT:
                return isSimilarLabel(item);

            case EDIT_COLOR:
                return isSimilarLabel(item);

            case SLIDE_FLOAT:
                return isSimilarLabel(item);

            case SLIDE_INT:
                return isSimilarLabel(item);

            case TEXT:
                return true;

            case BUTTON:
                return true;

            case CHECK:
                return isSimilarLabel(item);

        }

    }

    inline function isSimilarLabel(item:WindowItem):Bool {

        return ((item.string2 != null && string2 != null) || (item.string2 == null && string2 == null));

    }

    public function updateView(view:View):View {

        switch kind {

            case UNKNOWN:
                return view;

            case SELECT:
                return createOrUpdateSelectField(view);

            case EDIT_TEXT | EDIT_FLOAT | EDIT_INT:
                return createOrUpdateEditTextField(view);

            case EDIT_COLOR:
                return createOrUpdateColorField(view);

            case SLIDE_FLOAT | SLIDE_INT:
                return createOrUpdateSliderField(view);

            case TEXT:
                return createOrUpdateText(view);

            case BUTTON:
                return createOrUpdateButton(view);

            case CHECK:
                return createOrUpdateBooleanField(view);

        }

    }

    public function recycle() {

        kind = UNKNOWN;
        previous = null;
        int0 = 0;
        int1 = 0;
        labelPosition = 0;
        float0 = 0;
        float1 = 0;
        labelWidth = 0;
        float3 = 0;
        float4 = 0;
        bool0 = false;
        string0 = null;
        string1 = null;
        string2 = null;
        string3 = null;
        stringArray0 = null;

        pool.recycle(this);

    }

    function createOrUpdateSelectField(view:View):View {

        var field:SelectFieldView = null;
        var labeled:LabeledFieldView<SelectFieldView> = null;
        var justCreated = false;
        if (string2 != null) {
            labeled = (view != null ? cast view : null);
            if (labeled == null) {
                justCreated = true;
                field = new SelectFieldView();
                labeled = new LabeledFieldView(field);
            }
            else {
                field = labeled.field;
            }
            labeled.label = string2;
            labeled.labelPosition = labelPosition;
            labeled.labelWidth = labelWidth;
            switch labeled.labelPosition {
                case LEFT: field.align = LEFT;
                case RIGHT: field.align = RIGHT;
            }
        }
        else {
            field = (view != null ? cast view : null);
            if (field == null) {
                justCreated = true;
                field = new SelectFieldView();
            }
        }
        field.data = this;
        field.list = stringArray0;
        if (justCreated) {
            field.setValue = _selectSetIntValue;
        }
        var newValue = stringArray0[int0];
        if (newValue != field.value) {
            field.value = newValue;
        }
        return labeled != null ? labeled : field;

    }

    function createOrUpdateBooleanField(view:View):View {

        var field:BooleanFieldView = null;
        var labeled:LabeledFieldView<BooleanFieldView> = null;
        var justCreated = false;
        if (string2 != null) {
            labeled = (view != null ? cast view : null);
            if (labeled == null) {
                justCreated = true;
                field = new BooleanFieldView();
                labeled = new LabeledFieldView(field);
            }
            else {
                field = labeled.field;
            }
            field.viewWidth = ceramic.ViewSize.auto();
            labeled.label = string2;
            labeled.labelPosition = labelPosition;
            labeled.labelWidth = labelWidth;
        }
        else {
            field = (view != null ? cast view : null);
            if (field == null) {
                justCreated = true;
                field = new BooleanFieldView();
            }
        }
        field.data = this;
        var intValue = field.value ? 1 : 0;
        if (intValue != int0) {
            field.value = int0 != 0 ? true : false;
        }
        if (justCreated) {
            field.onValueChange(null, function(value, prevValue) {
                field.windowItem().int1 = value ? 1 : 0;
            });
        }
        return labeled != null ? labeled : field;

    }

    static function _selectSetIntValue(field:SelectFieldView, value:String):Void {

        final item = field.windowItem();
        final index = field.list.indexOf(value);
        item.int1 = index;

    }

    function createOrUpdateColorField(view:View):View {

        var field:ColorFieldView = null;
        var labeled:LabeledFieldView<ColorFieldView> = null;
        var justCreated = false;
        if (string2 != null) {
            labeled = (view != null ? cast view : null);
            if (labeled == null) {
                justCreated = true;
                field = new ColorFieldView();
                labeled = new LabeledFieldView(field);
            }
            else {
                field = labeled.field;
            }
            labeled.label = string2;
            labeled.labelPosition = labelPosition;
            labeled.labelWidth = labelWidth;
        }
        else {
            field = (view != null ? cast view : null);
            if (field == null) {
                justCreated = true;
                field = new ColorFieldView();
            }
        }

        var previous = field.windowItem();
        field.data = this;

        if (justCreated) {
            field.setValue = _editColorSetValue;
        }
        if (justCreated || previous.int1 != int0) {
            field.value = int0;
        }

        return labeled != null ? labeled : field;

    }

    static function _editColorSetValue(field:ColorFieldView, value:Color):Void {

        field.value = value;
        field.windowItem().int1 = value;

    }

    function createOrUpdateEditTextField(view:View):View {

        var field:TextFieldView = null;
        var labeled:LabeledFieldView<TextFieldView> = null;
        var justCreated = false;
        if (string2 != null) {
            labeled = (view != null ? cast view : null);
            if (labeled == null) {
                justCreated = true;
                field = new TextFieldView();
                labeled = new LabeledFieldView(field);
            }
            else {
                field = labeled.field;
            }
            labeled.label = string2;
            labeled.labelPosition = labelPosition;
            labeled.labelWidth = labelWidth;
        }
        else {
            field = (view != null ? cast view : null);
            if (field == null) {
                justCreated = true;
                field = new TextFieldView();
            }
        }

        var previous = field.windowItem();
        field.data = this;

        if (kind == EDIT_TEXT) {
            if (justCreated) {
                field.setValue = _editTextSetValue;
            }
            if (string0 != field.textValue) {
                field.textValue = string0;
            }
            field.multiline = bool0;
            field.placeholder = string3;
        }
        else if (kind == EDIT_FLOAT) {
            if (justCreated) {
                field.setTextValue = _editFloatSetTextValue;
                field.setEmptyValue = _editFloatSetEmptyValue;
                field.setValue = _editFloatSetValue;
                field.onFocusedChange(null, (focused, _) -> {
                    if (!focused)
                        _editFloatFinishEditing(field);
                });
            }
            if (justCreated || previous.float1 != float0) {
                field.textValue = '' + float0;
            }
        }
        else if (kind == EDIT_INT) {
            if (justCreated) {
                field.setTextValue = _editIntSetTextValue;
                field.setEmptyValue = _editIntSetEmptyValue;
                field.setValue = _editIntSetValue;
                field.onFocusedChange(null, (focused, _) -> {
                    if (!focused)
                        _editIntFinishEditing(field);
                });
            }
            if (justCreated || previous.int1 != int0) {
                field.textValue = '' + int0;
            }
        }

        return labeled != null ? labeled : field;

    }

    static function _editTextSetValue(field:BaseTextFieldView, value:String):Void {

        field.windowItem().string1 = value;

    }

    static function _editFloatSetTextValue(field:BaseTextFieldView, textValue:String):Void {

        if (!_editFloatOrIntOperations(field, textValue)) {
            var item = field.windowItem();
            var minValue = -999999999; // Allow lower value at this stage because we are typing
            var maxValue = item.float4;
            var decimals = item.int0;
            SanitizeTextField.setTextValueToFloat(field, textValue, minValue, maxValue, decimals);
        }

    }

    static function _editFloatSetEmptyValue(field:BaseTextFieldView):Void {

        final item = field.windowItem();
        var minValue = item.float3;
        var maxValue = item.float4;
        var decimals = item.int0;
        item.float1 = SanitizeTextField.setEmptyToFloat(field, minValue, maxValue, decimals);

    }

    static function _editFloatSetValue(field:BaseTextFieldView, value:Dynamic):Void {

        final item = field.windowItem();
        var minValue = item.float3;
        var maxValue = item.float4;
        var floatValue:Float = value;
        if (value >= minValue && value <= maxValue) {
            item.float1 = floatValue;
        }

    }

    static function _editFloatFinishEditing(field:BaseTextFieldView):Void {

        var item = field.windowItem();
        var minValue = item.float3;
        var maxValue = item.float4;
        var decimals = item.int0;
        if (!SanitizeTextField.applyFloatOrIntOperationsIfNeeded(field, field.textValue, minValue, maxValue, false, decimals)) {
            SanitizeTextField.setTextValueToFloat(field, field.textValue, minValue, maxValue, decimals);
            if (field.textValue.endsWith('.')) {
                field.textValue = field.textValue.substring(0, field.textValue.length - 1);
                field.invalidateTextValue();
            }
        }

    }

    static function _editIntSetTextValue(field:BaseTextFieldView, textValue:String):Void {

        if (!_editFloatOrIntOperations(field, textValue)) {
            var item = field.windowItem();
            var minValue = -999999999; // Allow lower value at this stage because we are typing
            var maxValue = Std.int(item.float4);
            SanitizeTextField.setTextValueToInt(field, textValue, minValue, maxValue);
        }

    }

    static function _editIntSetEmptyValue(field:BaseTextFieldView):Void {

        final item = field.windowItem();
        var minValue = Std.int(item.float3);
        var maxValue = Std.int(item.float4);
        item.int1 = SanitizeTextField.setEmptyToInt(field, minValue, maxValue);

    }

    static function _editIntSetValue(field:BaseTextFieldView, value:Dynamic):Void {

        final item = field.windowItem();
        var minValue = item.float3;
        var maxValue = item.float4;
        var intValue:Int = value;
        if (value >= minValue && value <= maxValue) {
            item.int1 = intValue;
        }

    }

    static function _editIntFinishEditing(field:BaseTextFieldView):Void {

        var item = field.windowItem();
        var minValue = Std.int(item.float3);
        var maxValue = Std.int(item.float4);
        if (!SanitizeTextField.applyFloatOrIntOperationsIfNeeded(field, field.textValue, minValue, maxValue, true, 0)) {
            SanitizeTextField.setTextValueToInt(field, field.textValue, minValue, maxValue);
        }

    }

    static function _editFloatOrIntOperations(field:BaseTextFieldView, textValue:String):Bool {

        // TODO move this somewhere else?

        var addIndex = textValue.indexOf('+');
        var subtractIndex = textValue.indexOf('-');
        var multiplyIndex = textValue.indexOf('*');
        var divideIndex = textValue.indexOf('/');
        if (addIndex > 0 && !(subtractIndex > 0 || multiplyIndex > 0 || divideIndex > 0)) {
            field.textValue = textValue.trim();
            if (textValue != field.textValue)
                field.invalidateTextValue();
            return true;
        }
        if (subtractIndex > 0 && !(addIndex > 0 || multiplyIndex > 0 || divideIndex > 0)) {
            field.textValue = textValue.trim();
            if (textValue != field.textValue)
                field.invalidateTextValue();
            return true;
        }
        if (multiplyIndex > 0 && !(addIndex > 0 || subtractIndex > 0 || divideIndex > 0)) {
            field.textValue = textValue.trim();
            if (textValue != field.textValue)
                field.invalidateTextValue();
            return true;
        }
        if (divideIndex > 0 && !(addIndex > 0 || multiplyIndex > 0 || subtractIndex > 0)) {
            field.textValue = textValue.trim();
            if (textValue != field.textValue)
                field.invalidateTextValue();
            return true;
        }

        return false;

    }

    function createOrUpdateSliderField(view:View):View {

        var field:SliderFieldView = null;
        var labeled:LabeledFieldView<SliderFieldView> = null;
        var justCreated = false;
        if (string2 != null) {
            labeled = (view != null ? cast view : null);
            if (labeled == null) {
                justCreated = true;
                field = new SliderFieldView();
                labeled = new LabeledFieldView(field);
            }
            else {
                field = labeled.field;
            }
            labeled.label = string2;
            labeled.labelPosition = labelPosition;
            labeled.labelWidth = labelWidth;
        }
        else {
            field = (view != null ? cast view : null);
            if (field == null) {
                justCreated = true;
                field = new SliderFieldView();
            }
        }

        var previous = field.windowItem();
        field.data = this;

        if (kind == SLIDE_FLOAT) {

            field.minValue = float3;
            field.maxValue = float4;
            field.decimals = int0;

            if (justCreated) {
                field.setTextValue = _editFloatSetTextValue;
                field.setEmptyValue = _editFloatSetEmptyValue;
                field.setValue = _slideFloatSetValue;
                field.onFocusedChange(null, (focused, _) -> {
                    if (!focused)
                        _editFloatFinishEditing(field);
                });
            }
            if (justCreated || previous.float1 != float0) {
                field.value = float0;
            }
        }
        else if (kind == SLIDE_INT) {

            field.minValue = float3;
            field.maxValue = float4;
            field.decimals = 0;

            if (justCreated) {
                field.setTextValue = _editIntSetTextValue;
                field.setEmptyValue = _editIntSetEmptyValue;
                field.setValue = _slideIntSetValue;
                field.onFocusedChange(null, (focused, _) -> {
                    if (!focused)
                        _editIntFinishEditing(field);
                });
            }
            if (justCreated || previous.int1 != int0) {
                field.value = int0;
            }
        }

        return labeled != null ? labeled : field;

    }

    static function _slideFloatSetValue(field:BaseTextFieldView, value:Float):Void {

        final item = field.windowItem();
        var sliderField:SliderFieldView = cast field;
        var minValue = item.float3;
        var maxValue = item.float4;
        var floatValue:Float = value;
        if (value >= minValue && value <= maxValue) {
            item.float1 = floatValue;
            var valueDidChange = (sliderField.value != value);
            sliderField.value = value;
        }

    }

    static function _slideIntSetValue(field:BaseTextFieldView, value:Float):Void {

        final item = field.windowItem();
        var sliderField:SliderFieldView = cast field;
        var minValue = item.float3;
        var maxValue = item.float4;
        var floatValue:Float = Math.round(value);
        if (value >= minValue && value <= maxValue) {
            item.int1 = Std.int(floatValue);
            var valueDidChange = (sliderField.value != value);
            sliderField.value = value;
        }

    }

    function createOrUpdateText(view:View):View {

        var text:LabelView = (view != null ? cast view : null);
        if (text == null) {
            text = new LabelView();
        }
        if (text.content != string0) {
            text.content = string0;
        }
        text.align = switch int0 {
            default: LEFT;
            case 1: RIGHT;
            case 2: CENTER;
        };
        return text;

    }

    function createOrUpdateButton(view:View):View {

        var button:Button = (view != null ? cast view : null);
        var justCreated = false;
        if (button == null) {
            justCreated = true;
            button = new Button();
        }
        if (button.content != string0) {
            button.content = string0;
        }
        if (button.enabled != bool0) {
            button.enabled = bool0;
        }
        button.data = this;
        if (justCreated) {
            button.onClick(null, function() {
                var windowItem:WindowItem = button.hasData ? button.data : null;
                if (windowItem != null) {
                    windowItem._buttonClick();
                }
            });
        }
        return button;

    }

    function _buttonClick():Void {

        int1 = 1;

    }

}

private class WindowItemExtensions {

    inline public static function windowItem(field:FieldView):WindowItem {
        return field.hasData ? field.data : null;
    }

}