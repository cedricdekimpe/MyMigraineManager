module MigrainesHelper
  def migraine_cell_classes(day, current_month)
    classes = ["px-3 py-2 text-center text-sm border border-slate-200"]

    if day.odd?
      classes << "bg-slate-900"
      text_class = "text-white"
    else
      classes << pastel_class_for(current_month)
      text_class = "text-slate-900"
    end

    max_day = current_month.end_of_month.day
    if day > max_day
      classes << "opacity-40"
      text_class = "text-slate-400"
    end

    classes << text_class
    classes.join(" ")
  end

  def pastel_class_for(month)
    case ((month.month - 1) / 3) % 3
    when 0
      "bg-amber-100"
    when 1
      "bg-rose-100"
    else
      "bg-sky-100"
    end
  end
end
