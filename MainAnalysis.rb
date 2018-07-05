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

parameters = []
File.open("properties", "r") do |text|
  indexLine = 0
  text.each_line do |line|
    parameters[indexLine] = line[/\<(.*?)\>/, 1]
    indexLine += 1
  end
end

mainAnalysis = MainAnalysis.new(parameters[0], parameters[1])

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
puts "Squash"
mainAnalysis.getGitProject.getSquashCommits.each do |log|
  puts "#{log.getFinalHash} - #{log.getAssociatedCommits}"
end

puts
puts "Rebase"
mainAnalysis.getGitProject.getRebaseCommits.each do |log|
  puts "#{log.getHashOne} - #{log.getHashTwo}"
end

puts
puts "Cherry-Pick"
mainAnalysis.getGitProject.getCherryPickCommits.each do |log|
  puts "#{log.getHash} - #{log.getDate}"
end