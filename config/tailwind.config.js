const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*'
  ],
  theme: {
    extend: {
      colors: {
        'mapzy-orange': '#F99B46',
        'mapzy-violet': '#704DCC',
        'mapzy-red': '#E74D67',
        'mapzy-red-light': '#EB7085',
        'mapzy-blue': '#62CFFF'
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    // Use mapzy-violet as underline color
    function ({addUtilities}) {
      const extendUnderline = {
          '.underline': {
              'textDecoration': 'underline',
              'text-decoration-color': '#E74D67',
          },  
      }
      addUtilities(extendUnderline)
    }
  ]
}
