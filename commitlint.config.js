// vim: filetype=js syntax=js softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
// code: language=js insertSpaces=true tabSize=2
module.exports = {
  extends: ["@commitlint/config-conventional"],
  rules: {
    "header-max-length": [0, "always", 72],
    "body-max-line-length": [0, "always", "Infinity"],
    "type-enum": [
      2,
      "always",
      [
        "build",
        "chore",
        "ci",
        "docs",
        "feat",
        "fix",
        "perf",
        "refactor",
        "release",
        "revert",
        "style",
        "test",
      ],
    ],
  },
};
