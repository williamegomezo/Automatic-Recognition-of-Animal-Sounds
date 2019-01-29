This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

## Table of Contents

- [Project information](#project-information)

## Project Information

### Folder structure

#### src folder:

- Components:
  All components of the project

### Boilerplates:

- This project uses Electron-React-Boilerplate (https://github.com/electron-react-boilerplate/electron-react-boilerplate) with some modifications:

#### Typescript removed.

#### Store was removed so far due to it is not needed.

### Linters: Eslint and Prettier

Linter configuration is set in the file .eslintrc
It includes:

- react-app (https://github.com/airbnb/javascript/tree/master/react).
- prettier: Code formatter.

Check this video: https://www.youtube.com/watch?v=bfyI9yl3qfE

Prettier and Eslint plugin of visual studio code must be installed (https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode).
Visual studio needs to be configured to use prettier one the user save the code:

Code -> Preferences -> Settings

Add the following to the JSON:

```
"editor.formatOnSave" : true,
"[javascript]": {
    "editor.formatOnSave": false
},
"eslint.autoFixOnSave": true,
"prettier.disableLanguages": [
    "js"
],
"files.autoSave": "onFocusChange"
```
