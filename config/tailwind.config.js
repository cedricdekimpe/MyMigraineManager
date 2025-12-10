module.exports = {
  content: [
    "./app/views/**/*.{erb,html}",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.{js,mjs,ts,tsx}"
  ],
  theme: {
    extend: {}
  },
  safelist: [
    "px-3",
    "py-2",
    "text-center",
    "text-sm",
    "border",
    "border-slate-200",
    "bg-slate-900",
    "bg-amber-100",
    "bg-rose-100",
    "bg-sky-100",
    "text-white",
    "text-slate-900",
    "text-slate-400",
    "opacity-40"
  ],
  plugins: []
}
