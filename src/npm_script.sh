#!/bin/bash

npmScriptRunCI() {
 commandPrintAndSave "npm ci"
}

npmScriptRunStart() {
  commandPrintAndSave "npm run start"
}

npmScriptRunTest() {
  commandPrintAndSave "npm run test${1}"
}

npmScriptRunLint() {
  commandPrintAndSave "npm run lint"
}

npmScriptRunBuild() {
  commandPrintAndSave "npm run build"
}