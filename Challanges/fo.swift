func feedOptimizer(span: Int, h: Int, events: [[Int]]) -> [[Int]] {
    
    var results = [[Int]]()
    var stories = [Int:[Int]]()
    var times = [Int:Int]()
    
    var start = 0
    var i = 0
    
    for event in events {
        switch event.count {
        case 3:
            if i == 0 {
                start = event[0]
            }
            
            i += 1
            stories[i] = event
            times[i] = event[0]
            
        case 1:
            let currentTime = event[0]
            let idsToDelete = times.filter { $0.value < currentTime - span }
            for (key, _ ) in idsToDelete {
                stories[key] = nil
                times[key] = nil
            }
            
            if stories.isEmpty == false {
                let result = getTopCombo(from: stories, h: h)
                results += [result]
                
            } else {
                results += [[0]]
            }
            
            
        default: break
            
        }
    }
    
    return results
}

struct Story {
    let index: Int
    let height: Int
    let score: Int
    init(_ index: Int, _ height: Int, _ score: Int) {
        self.index = index
        self.height = height
        self.score = score
    }
}

func getTopCombo(from storyDic: [Int:[Int]], h: Int) -> [Int] {
    
    var stories = [Story(0,0,0)]
    
    for (key, _ ) in storyDic {
        var l = storyDic[key]!
        let index = key
        let score = l[1]
        let height = l[2]
        let nStory = Story(index, height, score)
        stories.append(nStory)
    }
    
    stories.sort(by: {
        if $0.score == $1.score {
            return $0.index < $1.index
        }
        return $0.score > $1.score
    })
    
    if let last = stories.popLast() {
        stories.insert(last, at: 0)
    }
    
    let n = storyDic.count
    var m = Array.init(repeating: Array.init(repeating: 0, count: h + 1), count: n + 1)
    
    for i in 1...n {
        let story = stories[i]
        let height = story.height
        let score = story.score
        for j in 0...h {
            
            if height > j {
                m[i][j] = m[i-1][j]
            } else {
                let m1 = m[i-1][j]
                let m2 = m[i-1][j - height] + score
                m[i][j] = max(m1, m2)
            }
        }
    }
    
    var path = [Int]()
    var j = h //last item
    var i = n
    var indexes = [Int]()
    
    while i > 0 {
        if m[i][j] != m[i-1][j] {
            let story = stories[i]
            path.append(story.index)
            indexes.append(i-1)
            j -= story.height
        }
        i -= 1
    }
    
    
    return [m[n][h]] + path.sorted()
}


