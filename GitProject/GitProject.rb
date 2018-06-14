class GitProject

  def initialize(pathProject)
    @pathProject = pathProject
    @reflog = getReflogOfProject()
    @actionsLog = Array.new
    @mergeCommits = Array.new
    collectAllActionsFromReflog()
  end

  def getPathProject()
    @pathProject
  end

  def getReflog()
    @reflog
  end

  def getActionsLog()
    @actionsLog
  end

  def getReflogOfProject()
    actualPath = Dir.pwd
    Dir.chdir @pathProject
    logGit = StringIO.new(%x(git reflog --date=local))
    Dir.chdir actualPath
    return logGit
  end

  def collectAllActionsFromReflog()
    @reflog.each do |log|
      auxActionLog = ActionLog.new(log)
      @actionsLog.push(auxActionLog)
      if (auxActionLog.getCommand.include? 'merge')
        @mergeCommits.push(MergeCommit.new(auxActionLog.getGitHash, @pathProject))
      end
    end
  end

end