import { Controller } from "@hotwired/stimulus";
import jspreadsheet from "jspreadsheet-ce";

const days = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
]

const generateCols = () => {
  return [
    { type: "text", title: "Name", width: 220 },
    { type: "text", title: "Description", width: 240 },
    { type: "text", title: "Address", width: 330 },
    { type: "text", title: "No opening times?", width: 140 },
    ...days.reduce((prevArray, _day) => {
      const currentArray = [
        { type: "text", title: "Opens at", width: 80 },
        { type: "text", title: "Closes at", width: 80 }
      ]
      return prevArray.concat(currentArray)
    }, []),
  ]
}

const generateNestedHeaders = () => {
  return [
    [
        {
            title: "",
            colspan: "4",
        },
        ...days.reduce((prevArray, day) => {
          const currentArray = [
            {
              title: day,
              colspan: "2",
            },
          ]
          return prevArray.concat(currentArray)
        }, [])
    ],
  ]
}

const generateErrorStyles = (errors) => {
  const table = document.getElementsByClassName("jexcel")[0];

  Object.keys(errors).forEach((row) => {
    table.rows[row].classList.add("spreadsheet-error-row")
    errors[row]["cells"].forEach(cell => {
      table.rows[row].cells[cell].classList.add("spreadsheet-error-cell")
    });
  });
}

export default class extends Controller {
  static targets = [
    "spreadsheet",
    "importData",
    "importForm"
  ]

  static values = {
    errors: Object,
    spreadsheetData: Array
  }

  connect() {
    this.initSpreadsheet();
    generateErrorStyles(this.errorsValue);
  }

  initSpreadsheet() {
    this.spreadsheet = jspreadsheet(this.spreadsheetTarget, {
      data: this.spreadsheetDataValue,
      columns: generateCols(),
      nestedHeaders: generateNestedHeaders(),
      // disable the right-click menu
      // contextMenu: () => { return []; }
      tableOverflow: true,
      tableWidth: "1200px",
      tableHeight: "600px",
      freezeColumns: 1
    });
  }

  importData(e) {
    e.preventDefault();
    // update data in hidden field in form and submit it
    this.importDataTarget.value = JSON.stringify(this.spreadsheet.getJson());
    this.importFormTarget.submit();
  }
}