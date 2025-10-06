/** @type {import("stylelint").Config} */
export default {
  "extends": ["stylelint-config-gds/scss"],
  "rules": {
    "max-nesting-depth": 4,
    "selector-no-qualifying-type": [true, { ignore: ["class", "attribute"] }],
    "color-no-hex": true, // We should set colours as variables, not use explicit hex colours
    "selector-max-id": 1
  }
};
