require 'require_all'
require 'date'
require 'time'
require_all './GitProject'
require_all './BuildLog'

class MainAnalysis

  def initialize(pathLog, pathProject)
    @pathLogBuilds = pathLog
    @pathProject = pathProject
    @projectBuilds = ProjectBuilds.new(pathLog, pathProject)
    @gitProject = GitProject.new(pathProject)
  end

  def getPathLogBuilds()
    @pathLogBuilds
  end

  def getPathProject()
    @pathProject
  end

  def getProjectBuilds()
    @projectBuilds
  end

  def getGitProject()
    @gitProject
  end
end

pathDirectories = Array.new
ARGV.each do |pathOne|
  pathDirectories.push(pathOne)
end
#mainAnalysis = MainAnalysis.new(pathDirectories[0], pathDirectories[1])
mainAnalysis = MainAnalysis.new("/home/paulo/", "/home/paulo/Documentos/PHD/projects/okhttp")

puts "MAVEN - LOGS"
mainAnalysis.getProjectBuilds().getMavenLogs().each do |algo|
  puts algo.getPathLog()
end

puts
puts "GIT - LOGS"
mainAnalysis.getGitProject.getActionsLog().each do |algo|
  puts algo.getOriginalLine()
end

