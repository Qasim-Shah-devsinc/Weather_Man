require 'csv'
require 'colorize'
require 'date'

# to verify length of Arguments
  def Argument_Length_Verify()
    if ARGV.length != 3
      puts "Wrong Arguments given"
      return false
    else
      return true
    end
  end
  # to verify content of Argument are Valid
  def Argument_Content_Verify()
    if ARGV[0] == '-e' || ARGV[0] == '-c' || ARGV[0] == '-a'
      path_loc= ARGV[2].split("/")
      date_path = ARGV[1].split("/")
      if path_loc[4] == "Dubai_weather"
        if date_path[0].to_i >= 2004 && date_path[0].to_i <= 2016
            return true
        end
      end
      if path_loc[4] == "lahore_weather"
        if date_path[0].to_i >= 1996 && date_path[0].to_i <= 2011
            return true
        end
      end
      if path_loc[4] == "Murree_weather"
        if date_path[0].to_i >= 2004 && date_path[0].to_i <= 2016
            return true
        end
      end
    else
      puts "Argument is wrong"
      return false
    end
  end
  #module to verify arguments
  def Argument_Check()
    flag_length = Argument_Length_Verify()
    flag_content = Argument_Content_Verify()
    if flag_length && flag_content
      return true
    else
      "Wrong arguments"
      return false
    end
  end

class Weather_Man
  #make Path
  def makePath()
    path_loc= ARGV[2].split("/")
    string_path = "#{ARGV[2]}#{path_loc[4]}_#{ARGV[1]}_"
    return string_path
  end
  #make Path for 2 and 3 case
  def makePath1()
    months = ['0','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']
    date_path = ARGV[1].split("/")
    month_path = date_path[1].to_i
    year_path = date_path[0].to_i
    month_name  = months[month_path]
    path_loc= ARGV[2].split("/")
    default_path = path_loc[4]
    default_path = "#{ARGV[2]}#{default_path}_#{year_path}_#{month_name}.txt"
    return default_path
  end
  #highest,lowest and humidity from month
  def month_result_1(p)
    path = p
    data_file = CSV.parse(File.read(path), headers: true)
    result = {}
    i = 1
    highest_temp = 0
    hday = 0
    lowest_temp = 100
    lday = 0
    most_humid = 0
    mday = 0
    for i in 0..(data_file.length-1) do
      if !(data_file[i][1].nil?)
        if highest_temp.to_i < data_file[i][1].to_i
          highest_temp = data_file[i][1]
          hday = i+2
        end
      end
      if !(data_file[i][3].nil?)
        if lowest_temp.to_i > data_file[i][3].to_i
          lowest_temp = data_file[i][3]
          lday = i+2
        end
      end
      if !(data_file[i][7].nil?)
        if most_humid.to_i < data_file[i][7].to_i
          most_humid = data_file[i][7]
          mday = i+2
        end
      end
    end
    result = { ":Highest" => highest_temp , ":Lowest"=> lowest_temp , ":Humid"=> most_humid , ":h"=>hday,":l"=>lday,":m"=>mday }
    return result
  end
  #do task 1 of Weather Man
  def task1_e()
    mhighest_temp = 0
    mhday = 0
    mlowest_temp = 10
    mlday = 0
    mmost_humid = 0
    mmday = 0
    results = {}
    i = 1
    for i in 1..12 do
      path =  makePath() +"#{Date::ABBR_MONTHNAMES[i]}.txt"
      if (File.exist?(path))
        result = month_result_1(path)
        month_highest = result[":Highest"].to_i
        month_lowest = result[":Lowest"].to_i
        month_humid = result[":Humid"].to_i
        if mhighest_temp.to_i < result[":Highest"].to_i
          mhighest_temp = result[":Highest"].to_i
          mhday = i
          hday = result[":h"]
        end
        if mlowest_temp.to_i > result[":Lowest"].to_i
          mlowest_temp = result[":Lowest"].to_i
          mlday = i
          lday = result[":l"]
        end
        if mmost_humid.to_i < result[":Humid"].to_i
          mmost_humid = result[":Humid"].to_i
          mmday = i
          mday = result[":m"]
        end
      end
      string_highest = "#{mhighest_temp}C on #{Date::ABBR_MONTHNAMES[mhday]} #{hday}"
      string_lowest = "#{mlowest_temp}C on  #{Date::ABBR_MONTHNAMES[mlday]} #{lday}"
      string_humid = "#{mmost_humid}% on  #{Date::ABBR_MONTHNAMES[mmday]} #{mday}"
      results = { ":Highest" => string_highest , ":Lowest"=> string_lowest , ":Humid"=> string_humid  }
    end
    puts "Highest: #{results[":Highest"]}  \nLowest: #{results[":Lowest"]}    \nHumid: #{results[":Humid"]}"
  end
  #average temp from month
  def month_result_2(p)
    path = p
    data_file = CSV.parse(File.read(path), headers: true)
    result = {}
    i = 1
    highest_avg = 0
    lowest_avg = 100
    avg_humid = 0
    for i in 0..(data_file.length-1) do
       if !(data_file[i][2].nil?)
          if highest_avg.to_i < data_file[i][2].to_i
            highest_avg = data_file[i][2]
          end
        end
        if !(data_file[i][2].nil?)
          if lowest_avg.to_i > data_file[i][2].to_i
            lowest_avg = data_file[i][2]
          end
        end
        if !(data_file[i][8].nil?)
          if avg_humid.to_i < data_file[i][8].to_i
            avg_humid = data_file[i][8]
          end
      end
    end
      result = { ":Highest" => highest_avg , ":Lowest"=> lowest_avg , ":Humid"=> avg_humid  }
    return result
  end
  #do task 2 of Weather Man
  def task2_a()
    results = {}
    path =  makePath1()
    if (File.exist?(path))
      result = month_result_2(path)
      puts "Highest Average: #{result[":Highest"]}C  \nLowest Average: #{result[":Lowest"]}C    \nAverage Humid: #{result[":Humid"]}%"
    end
  end
  #display chart of highest and lowest temp of each day of month
  def month_result_3(p)
    path = p
    data_file = CSV.parse(File.read(path), headers: true)
    i = 0
    string_color = ""
    if ARGV[0] == '-c'
      for i in 0..(data_file.length-1) do
          if !(data_file[i][1].nil?)
            counter = "#{i+1} "
            for j in 1..(data_file[i][1].to_i - 1) do
              string_color = string_color + "+".red
            end
            string_full = " #{counter} #{string_color} #{data_file[i][1]}C"
            puts string_full
            string_full = "",string_color = ""
          end
          if !(data_file[i][3].nil?)
            counter = "#{i+1} "
            for j in 1..(data_file[i][3].to_i - 1) do
              string_color = string_color + "+".blue
            end
            string_full = " #{counter} #{string_color} #{data_file[i][3]}C"
            puts string_full
            string_full = "",string_color = ""
          end
        end
    end
  end
  #do task 3 of Weather Man
  def task3_c()
      path =  makePath1()
      if (File.exist?(path))
        month_result_3(path)
      end
  end
end
#Main
flag_argument = Argument_Check()
if flag_argument
  if ARGV[0]== '-e'
    Weather_Man.new.task1_e()
  end
  if ARGV[0]== '-a'
    Weather_Man.new.task2_a()
  end
  if ARGV[0]== '-c'
    Weather_Man.new.task3_c()
  end
end
