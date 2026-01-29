class LikertScale {
 final int value;
 final int minValue;
 final int maxValue;

 LikertScale(this.value, {this.minValue = 1, this.maxValue = 5})
      : assert(value >= minValue && value <= maxValue,
            'Value must be between $minValue and $maxValue',);
}
