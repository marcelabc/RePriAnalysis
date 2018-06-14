class ProjectBuilds

  def initialize(pathLog, pathProject)
    @pathLog = pathLog
    @projectName = findProjectName(pathProject)
    @mavenLogs = collectAllActions()
  end

  def getPathLog()
    @pathLog
  end

  def getMavenLogs()
    @mavenLogs
  end

  def getProjectName()
    @projectName
  end

  def findProjectName(pathProject)
    return pathProject.to_s.split("/").last.to_s.gsub("\"]","")
  end

  def collectAllActions()
    actualPath = Dir.pwd
    Dir.chdir @pathLog
    auxAllActions = Array.new
    Dir.glob("*.log").each do |oneFile|
      if File.readlines(oneFile).any?{ |l| l['BUILD FAILURE'] }
        if File.readlines(oneFile).any?{ |l| l[@projectName] }
          auxAllActions.push(MavenLog.new(oneFile))
        end
      end
    end

    Dir.chdir actualPath
    return auxAllActions
  end
end