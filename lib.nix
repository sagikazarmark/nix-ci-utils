{ lib }:

let
  # Concat attribute values with a separator
  concatAttrValuesSep = attrs: sep: lib.strings.concatStringsSep sep (lib.attrsets.attrValues attrs);

  # Concat attribute values with a default separator ("_")
  concatAttrValuesDef = attrs: concatAttrValuesSep attrs "_";

  # Convert an attribute set to a CI shell name.
  attrValuesToShellName = attrs: "ci_${(concatAttrValuesDef attrs)}";

  # Convert a string to a CI shell name.
  stringToShellName = s: "ci_${s}";

  # Generate an attribute set from an input.
  genAttrs = input: nameFn: valFn: lib.attrsets.listToAttrs (map (v: lib.attrsets.nameValuePair (nameFn v) (valFn v)) input);
in
rec {
  # Generate shells from a matrix attribute set.
  genShellsFromMatrixAttrs = config: outputFn: genAttrs (lib.attrsets.cartesianProductOfSets config) attrValuesToShellName outputFn;

  # Generate shells from a list of strings.
  genShellsFromList = config: outputFn: genAttrs config stringToShellName outputFn;
}
