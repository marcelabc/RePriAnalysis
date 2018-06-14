class MergeCommit

  def initialize(gitHash, pathProject)
    @mergeCommit = gitHash
    @mergeParents = findMergeParents(pathProject)
  end

  def getMergeCommit()
    @mergeCommit
  end

  def getMergeParents()
    @mergeParents
  end

  def findMergeParents(pathProject)
    actualPath = Dir.pwd
    Dir.chdir pathProject
    parentsCommit = []

    commitType = %x(git cat-file -p #{@mergeCommit})
    commitType.each_line do |line|
      if(line.include?('author'))
        break
      end
      if(line.include?('parent'))
        commitSHA = line.partition('parent ').last.gsub("\n","").gsub(' ','').gsub('\r','')
        parentsCommit.push(commitSHA)
      end
    end

    Dir.chdir actualPath
    return parentsCommit
  end
end