const {
  uniqueNamesGenerator,
  colors,
  animals,
  names,
} = require("unique-names-generator");

const folderName = uniqueNamesGenerator({
  dictionaries: [colors, animals, names],
  separator: "-",
  type: "lowerCase",
});

console.log(folderName);
