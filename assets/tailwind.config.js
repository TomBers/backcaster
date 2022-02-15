module.exports = {
  mode: 'jit',
  purge: [
    './js/**/*.js',
    '../lib/*_web/**/*.*ex',
    '../lib/*_web/**/*.sface'
  ],
  plugins: [
    require('@tailwindcss/typography'),
    require('daisyui')
  ],
}
