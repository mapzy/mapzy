module.exports = {
  purge: [
    "./app/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      colors: {
        'mapzy-orange': '#F99B46',
        'mapzy-violet': '#704DCC',
        'mapzy-red': '#E74D67',
        'mapzy-blue': '#62CFFF'
      },
    },
  },
  plugins: [
    // Use mapzy-violet as underline color
    function ({addUtilities}) {
      const extendUnderline = {
          '.underline': {
              'textDecoration': 'underline',
              'text-decoration-color': '#704DCC',
          },  
      }
      addUtilities(extendUnderline)
    }
  ]
}