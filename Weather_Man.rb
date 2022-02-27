require 'csv'
require 'colorize'
require 'date'

module Path
  def make_path_for_case1()
    str_arr = Array.new
    for i in 1..12 do
      path_loc= ARGV[2].split("/")
      string_path = "#{ARGV[2]}#{path_loc[4]}_#{ARGV[1]}_#{Date::ABBR_MONTHNAMES[i]}.txt"
      str_arr.push("#{string_path}") if (File.exist?(string_path))
    end
    return str_arr
  end

  def make_path_for_case2()
    date_path = ARGV[1].split("/")
    month_path = date_path[1].to_i
    year_path = date_path[0].to_i
    month_name  = Date::ABBR_MONTHNAMES[month_path]
    path_loc= ARGV[2].split("/")
    default_path = "#{ARGV[2]}#{path_loc[4]}_#{year_path}_#{month_name}.txt"
    return default_path
  end
end

class Argument

  attr_accessor :specifier
  attr_accessor :time
  attr_accessor :path
  attr_reader :length

  def initialize()
    @specifier = ARGV[0]
    @time = ARGV[1]
    @path = ARGV[2]
  end
  def argument?()
      if ARGV.length == 3
        if @specifier == '-e' || @specifier == '-c' || @specifier == '-a'
          path_loc= @path.split("/")
          date_path = @time.split("/")
          if path_loc[4] == "Dubai_weather"
              return true if date_path[0].to_i >= 2004 && date_path[0].to_i <= 2016
          end
          if path_loc[4] == "lahore_weather"
              return true if date_path[0].to_i >= 1996 && date_path[0].to_i <= 2011
          end
          if path_loc[4] == "Murree_weather"
              return true if date_path[0].to_i >= 2004 && date_path[0].to_i <= 2016
          end
        else
          puts "Arguments are wrong"
          return false
        end
      end
    end
end

class DataReader
  include Path
  attr_accessor :data_file

  def read_from_path(path_arr)
    year_data = Array.new
    for i in 0..(path_arr.length-1) do
      data_month = CSV.parse(File.read(path_arr[i]), headers: true)
      year_data.push(data_month)
    end
    return year_data
  end

  def read_from_path1(path_arr)
    return  CSV.parse(File.read(path_arr), headers: true)
  end
end

class DataStructure
  attr_accessor :highest_temp
  attr_accessor :highest_day
  attr_accessor :highest_month
  attr_accessor :lowest_temp
  attr_accessor :lowest_day
  attr_accessor :lowest_month
  attr_accessor :most_humid
  attr_accessor :most_humid_day
  attr_accessor :most_humid_month
  attr_accessor :highest_avg
  attr_accessor :lowest_avg
  attr_accessor :avg_humidity
  attr_accessor :max_temp
  attr_accessor :low_temp

  def initialize()
    @highest_temp = 0
    @highest_day = 0
    @highest_month = 0
    @lowest_temp = 40
    @lowest_day = 0
    @lowest_month = 0
    @most_humid = 0
    @most_humid_day = 0
    @most_humid_month = 0
    @highest_avg = 0
    @lowest_avg = 40
    @avg_humidity = 0
    @max_temp = []
    @low_temp = []
  end
end

class Compute

  def month_highest(data_year,obj2)
    for i in 0..(data_year.length-1)
      for j in 0..(data_year[i].length-1)
        if !(data_year[i][j][1].nil?)
          if data_year[i][j][1].to_i > obj2.highest_temp.to_i
            obj2.highest_temp = data_year[i][j][1].to_i
            split_date = data_year[i][j][0].split('-')
            obj2.highest_month = split_date[1]
            obj2.highest_day = split_date[2]
          end
        end
        if !(data_year[i][j][7].nil?)
          if data_year[i][j][7].to_i > obj2.most_humid.to_i
            obj2.most_humid = data_year[i][j][7].to_i
            split_date = data_year[i][j][0].split('-')
            obj2.most_humid_month = split_date[1]
            obj2.most_humid_day = split_date[2]
          end
        end
        if !(data_year[i][j][3].nil?)
          if data_year[i][j][3].to_i < obj2.lowest_temp.to_i
            obj2.lowest_temp = data_year[i][j][3].to_i
            split_date = data_year[i][j][0].split('-')
            obj2.lowest_month = split_date[1]
            obj2.lowest_day = split_date[2]
          end
        end
      end
    end
      return obj2
  end

  def month_average(month_data,obj)
    for i in 0..(month_data.length-1) do
       if !(month_data[i][2].nil?)
          if obj.highest_avg.to_i < month_data[i][2].to_i
            obj.highest_avg = month_data[i][2]
          end
        end
        if !(month_data[i][2].nil?)
          if obj.lowest_avg.to_i > month_data[i][2].to_i
            obj.lowest_avg = month_data[i][2]
          end
        end
        if !(month_data[i][8].nil?)
          obj.avg_humidity = obj.avg_humidity.to_i + month_data[i][8].to_i
        end
    end
    obj.avg_humidity = obj.avg_humidity/month_data.length
    return obj
  end

  def month_stats(month_data,obj)
    for i in 0..(month_data.length-1) do
      obj.max_temp.push(month_data[i][1]) if !(month_data[i][1].nil?)
      obj.low_temp.push(month_data[i][3]) if !(month_data[i][3].nil?)
    end
    return obj
  end
end

class Report

  def show_year_stats(obj)
    puts "Highest: #{obj.highest_temp}C on #{Date::ABBR_MONTHNAMES[obj.highest_month.to_i]} #{obj.highest_day}"
    puts "Lowest: #{obj.lowest_temp}C on #{Date::ABBR_MONTHNAMES[obj.lowest_month.to_i]} #{obj.lowest_day}"
    puts "Lowest: #{obj.most_humid}% on #{Date::ABBR_MONTHNAMES[obj.most_humid_month.to_i]} #{obj.most_humid_day}"
  end

  def month_avg_stats(obj)
    puts"Highest Average: #{obj.highest_avg}C"
    puts"Lowest Average: #{obj.lowest_avg}C"
    puts"Average Humidity: #{obj.avg_humidity}%"
  end

  def two_horizontal_chart(obj)
    string_color  = ""

    for i in 0..obj.max_temp.length-1 do
      counter = "#{i+1} "
      for j in 1..(obj.low_temp[i].to_i - 1) do
        string_color = string_color + "+".blue
      end
      string_full = " #{counter} #{string_color} "

      counter = "#{i+1} "
      for j in 1..(obj.max_temp[i].to_i - 1) do
        string_color = string_color + "+".red
      end
      string_full = " #{counter} #{string_color} #{obj.low_temp[i]}C - #{obj.max_temp[i]}C"
      puts string_full

      string_full = "",string_color = ""
    end
  end

  def one_horizontal_chart(obj)
    string_color  = ""

    for i in 0..obj.max_temp.length-1 do
      counter = "#{i+1} "
      for j in 1..(obj.low_temp[i].to_i - 1) do
        string_color = string_color + "+".blue
      end
      string_full = " #{counter} #{string_color} #{obj.low_temp[i]}C"
      puts string_full
      string_full = "",string_color = ""

      counter = "#{i+1} "
      for j in 1..(obj.max_temp[i].to_i - 1) do
        string_color = string_color + "+".red
      end
      string_full = " #{counter} #{string_color}  #{obj.max_temp[i]}C"
      puts string_full

      string_full = "",string_color = ""
    end
  end
end


class Weather_Man

  def run_task
    case ARGV[0]
    when "-e"
      if Argument.new.argument?
        obj1 = DataReader.new
        path_arr = obj1.make_path_for_case1()
        year_arr =  obj1.read_from_path(path_arr)
        obj = Compute.new
        obj2 = DataStructure.new
        obj3 =  obj.month_highest(year_arr,obj2)
        obj4 = Report.new
        obj4.show_year_stats(obj3)
      end
    when "-a"
      if Argument.new.argument?
        obj1 = DataReader.new
        path_arr = obj1.make_path_for_case2()
        months_arr =  obj1.read_from_path1(path_arr)
        obj = Compute.new
        obj2 = DataStructure.new
        obj3 =  obj.month_average(months_arr,obj2)
        obj4 = Report.new
        obj4.month_avg_stats(obj3)
      end
    when "-c"
      if Argument.new.argument?
        obj1 = DataReader.new
        path_arr = obj1.make_path_for_case2()
        months_arr =  obj1.read_from_path1(path_arr)
        obj = Compute.new
        obj2 = DataStructure.new
        obj3 =  obj.month_stats(months_arr,obj2)
        obj4 = Report.new
        obj4.two_horizontal_chart(obj3)
        #obj4.one_horizontal_chart(obj3)
     end
    end

  end
end

weather_obj = Weather_Man.new.run_task

