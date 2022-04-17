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

const sampleData = [
  [
    "Joe's Pasta Shop",
    "Fresh pasta from the legendary recipe which has been passed down from generation to generation to Joe",
    "200 Kent Ave, Brooklyn, NY 11249, United States",
    "",
    "08:00", "18:00", // monday
    "08:00", "18:00", // tuesday
    "", "", // wednesday
    "08:00", "18:00",// thursday
    "24", "24", // friday
    "08:00", "16:00",// saturday
    "", "", // sunday
  ], [], [], [], [], [], [], [], [], []
]

const generateCols = () => {
  return [
    { type: "text", title: "Name", width: 240 },
    { type: "text", title: "Description", width: 240 },
    { type: "text", title: "Address", width: 300 },
    { type: "text", title: "No opening times?", width: 200 },
    ...days.reduce((prevArray, _day) => {
      const currentArray = [
        { type: "text", title: "Opening time", width: 160 },
        { type: "text", title: "Closing time", width: 160 }
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

export default class extends Controller {
  static targets = [
    "spreadsheet",
    "importData",
    "importForm"
  ]

  connect() {
    this.initSpreadsheet()
  }

  initSpreadsheet() {
    this.spreadsheet = jspreadsheet(this.spreadsheetTarget, {
      data: sampleData,
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