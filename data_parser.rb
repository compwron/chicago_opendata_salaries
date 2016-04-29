require 'csv'

b = CSV.parse(File.open("Current_Employee_Names__Salaries__and_Position_Titles.csv")).reject{|c| c.first.nil? }

JOB_TITLE = 1
DEPARTMENT = 2
SALARY = 3


def salary(row)
  row[3].gsub("$", "").to_i || 0
end

def average_salary(rows)
  rows.map { |c| salary(c) }.inject(&:+) / rows.count
end

puts "lowest salaries"
puts b.sort_by {|c|
  salary(c)
}[0..10].map {|c| c.join(" ")}

d = b.group_by {|c|
  c[DEPARTMENT]
}

d.sort_by {|k, v|
  v.count
}.map {|department_name, v|
  puts department_name
  puts "#{v.count} people with an average salary of #{average_salary(v)}"
  sals = v.sort_by {|i|
    salary(i)
  }
  lowest_sal = sals[0..2].map {|i|
    "#{i[JOB_TITLE]}: #{i[SALARY]}"
  }.join(", ")
  highest_sal = (sals[sals.count - 3, sals.count - 1] || []).map {|i|
    "#{i[1]}: #{i[3]}"
  }.join(", ")
  puts "Lowest salaries: #{lowest_sal}"
  puts "Highest salaries: #{highest_sal}", ""
}

