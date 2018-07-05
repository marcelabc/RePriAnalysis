class GitProject

  def initialize(pathProject, mavenLogs)
    @pathProject = pathProject
    @reflog = getReflogOfProject()
    @actionsLog = Array.new
    @mergeCommits = Array.new
    @rebaseCommits = Array.new
    @squashCommits = Array.new
    @cherryPickCommits = Array.new
    collectAllActionsFromReflog(mavenLogs)
    @mergeWithLogs = Array.new
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

  def getRebaseCommits()
    @rebaseCommits
  end

  def getMergeCommits()
    @mergeCommits
  end

  def getMergeWithLogs()
    @mergeWithLogs
  end

  def getSquashCommits()
    @squashCommits
  end

  def getCherryPickCommits()
    @cherryPickCommits
  end

  def getReflogOfProject()
    actualPath = Dir.pwd
    logGit = []
    begin
      Dir.chdir @pathProject
      logGit = StringIO.new(%x(git reflog --date=local))
      Dir.chdir actualPath
    rescue Exception => e
      puts e.message
      puts "Inexistent git repository locally"
    end
    return logGit
  end

  def collectAllActionsFromReflog(mavenLogs)
    newRebase = false
    rebaseCommitAux = ""
    dateRebaseAux = ""
    newSquash = false
    currentSquash = SquashCommit.new
    squashCommitAux = ""
    @reflog.each do |log|
      auxActionLog = ActionLog.new(log)
      auxActionLog.setAssociatedLogs(findAssociatedLog(mavenLogs, auxActionLog.getGitHash))
      @actionsLog.push(auxActionLog)

      if (@mergeCommits.size == 0)
        @mergeCommits.push(MergeCommit.new(auxActionLog.getGitHash, @pathProject, auxActionLog.getDate))
      elsif (auxActionLog.getCommand.include? 'merge')
        @mergeCommits.push(MergeCommit.new(auxActionLog.getGitHash, @pathProject, auxActionLog.getDate))
      elsif (auxActionLog.getCommand.include? 'clone')
        @mergeCommits.push(MergeCommit.new(auxActionLog.getGitHash, @pathProject, auxActionLog.getDate))
      end

      if (auxActionLog.getOriginalLine.include? 'rebase finished')
        newRebase = true
        rebaseCommitAux = auxActionLog.getGitHash
        dateRebaseAux = auxActionLog.getDate
      elsif (newRebase == true and auxActionLog.getOriginalLine.include? 'rebase: checkout')
        @rebaseCommits.push(Rebase.new(rebaseCommitAux, auxActionLog.getGitHash, dateRebaseAux,auxActionLog.getDate))
        newRebase = false
        rebaseCommitAux = ""
        dateRebaseAux = ""
      end

      if (auxActionLog.getCommand() == " rebase -i (finish)")
        currentSquash = SquashCommit.new
        newSquash = true
        currentSquash.setFinalHash(auxActionLog.getGitHash)
        squashCommitAux = auxActionLog.getGitHash
      elsif (auxActionLog.getOriginalLine.include? "rebase: aborting" and newSquash)
        currentSquash = nil
        newSquash = false
      elsif ((auxActionLog.getCommand() == " rebase -i (squash)" or auxActionLog.getCommand() == " rebase -i (pick)") and newSquash)
        currentSquash.addAssociatedCommit(auxActionLog.getGitHash)
      elsif (auxActionLog.getCommand() == " rebase -i (start)" and newSquash)
        newSquash = false
        @squashCommits.push(currentSquash)
      end

      if (auxActionLog.getCommand == " cherry-pick")
        @cherryPickCommits.push(CherryPick.new(auxActionLog.getGitHash, auxActionLog.getDate))
      end
    end
  end

  def findAssociatedLog(mavenLogs, gitHash)
    associatedLogs = []
    mavenLogs.each do |log|
      if (log.getGitHash.include? gitHash[0..6].to_s)
        associatedLogs.push(log)
      end
    end
    return associatedLogs
  end

  def associateLogToCommitGroup(mavenLogs)
    buildLogs = []
    mavenLogs.each do |log|
      buildLogs.push(log)
    end
    count = 0
    while(count < @mergeCommits.size-1)
      mergeWithLog = MergeWithLog.new(@mergeCommits[count], @mergeCommits[count+1])
      buildLogs.each do |oneLog|
        if (oneLog.getDate() > @mergeCommits[count+1].getDate())
          mergeWithLog.addBuildLog(oneLog)
        end
      end

      mergeWithLog.getBuildLogs.each do |oneLog|
        buildLogs.delete(oneLog)
      end

      @mergeWithLogs.push(mergeWithLog)
      mergeWithLog = nil
      count += 1
    end
  end

  def findDateActionLogFromHash(gitHash)
    @actionsLog.each do |actionLog|
      if (actionLog.getGitHash == gitHash)
        return actionLog.getDate
      end
    end
    return ""
  end

end