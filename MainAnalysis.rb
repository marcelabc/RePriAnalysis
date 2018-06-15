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
    @gitProject = GitProject.new(pathProject, @projectBuilds.getMavenLogs)
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

mainAnalysis.getGitProject().associateLogToCommitGroup(mainAnalysis.getProjectBuilds().getMavenLogs())
puts
puts "GIT - MERGES/LOGS"
mainAnalysis.getGitProject.getMergeWithLogs().each do |algo|
  puts "#{algo.getCommitOne().getMergeCommit()} - #{algo.getCommitTwo().getMergeCommit}"
  algo.getBuildLogs().each do |outroAlgo|
    puts "#{outroAlgo.getPathLog}"
  end
  puts
  puts
end

puts "MAVEN - LOGS"
mainAnalysis.getProjectBuilds.getMavenLogs.each do |algo|
  puts algo.getPathLog
end

puts
puts "ACTIONS"
mainAnalysis.getGitProject.getActionsLog.each do |log|
  puts "#{log.getGitHash} - #{log.getAssociatedLogs().size}"
end

