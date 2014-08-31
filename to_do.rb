require 'active_record'
require './lib/task'

database_configuration = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configuration["development"]
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  puts "Welcome to the to_do list!"
  menu
end

def menu
  choice = nil
  until choice == 'e'
    puts "Press 'a' to add a task, 'l' to list your tasks, or 'd' to mark your tasks as done"
    puts "Press 'e' to exit"
    choice = gets.chomp.downcase
    case choice
    when 'a'
      add
    when 'l'
      list
    when 'd'
      mark_done
    when 'e'
      puts "Goodbye!"
    else
      puts "That wasn't a valid option. Try again"
    end
  end
end

def add
  puts "What do you want to do?"
  task_name = gets.chomp
  task = Task.new(name: task_name, done: false)
  task.save
  puts "'#{task_name}' has been added to your todo list."
end

def mark_done
  puts "Which of these tasks would you like to mark as done?"
  Task.all.each { |task| puts task.name }
  done_task_name = gets.chomp
  done_task = Task.where(name: done_task_name).first
  done_task.update_attributes(done: true)
end

def list
  puts "Here is everything you need to do:"
  tasks = Task.all
  tasks.each {|task| puts task.name}
end

welcome