class SquashCommit

  def initialize()
    @finalHash = ""
    @associatedCommits = Array.new
  end

  def setFinalHash(commit)
    @finalHash = commit
  end

  def getFinalHash()
    @finalHash
  end

  def getAssociatedCommits()
    @associatedCommits
  end

  def addAssociatedCommit(commit)
    if (commit != getFinalHash)
      @associatedCommits.push(commit)
    end
  end

end