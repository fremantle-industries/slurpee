const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
    mode: 'jit',
    purge: [
        '../config/runtime.exs',
        '../lib/**/*.ex',
        '../lib/**/*.leex',
        '../lib/**/*.eex',
        '../deps/**/*.ex',
        '../deps/**/*.leex',
        '../deps/**/*.eex',
        './js/**/*.js',
        './js/**/*.jsx',
        './js/**/*.ts',
        './js/**/*.tsx'
    ],
    darkMode: false, // or 'media' or 'class'
    theme: {
        extend: {
            fontFamily: {
                // Free Proxima Nova alternative
                sans: ['Montserrat', ...defaultTheme.fontFamily.sans],
            },
        },
    },
    variants: {
        display: ['responsive', 'empty'],
        extend: {
            opacity: ['disabled'],
            visibility: ['group-hover'],
        },
    },
    plugins: [
        require('@tailwindcss/forms'),
        require('tailwindcss-empty-pseudo-class')()
    ],
}
