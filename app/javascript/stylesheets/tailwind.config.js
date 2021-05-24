module.exports = {
  purge: [
    "./app/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
  ],
  darkMode: false, // or 'media' or 'class'
  variants: {},
  plugins: [
    // Use indigo-700 (#3730a3) as underline color
    function ({addUtilities}) {
      const extendUnderline = {
          '.underline': {
              'textDecoration': 'underline',
              'text-decoration-color': '#3730a3',
          },  
      }
      addUtilities(extendUnderline)
    }
  ],
  theme: {
    extend: {
    },
  }
}