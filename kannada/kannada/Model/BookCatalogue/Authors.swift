/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Authors {
	public var authorid : String?
	public var authorname : String?
	public var authorimage : String?
	public var authorabout : String?
	public var books : Array<Books>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let authors_list = Authors.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Authors Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Authors]
    {
        var models:[Authors] = []
        for item in array
        {
            models.append(Authors(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let authors = Authors(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Authors Instance.
*/
	required public init?(dictionary: NSDictionary) {

		authorid = dictionary["authorid"] as? String
		authorname = dictionary["authorname"] as? String
		authorimage = dictionary["authorimage"] as? String
		authorabout = dictionary["authorabout"] as? String
        if (dictionary["books"] != nil) { books = Books.modelsFromDictionaryArray(array: dictionary["books"] as! NSArray) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.authorid, forKey: "authorid")
		dictionary.setValue(self.authorname, forKey: "authorname")
		dictionary.setValue(self.authorimage, forKey: "authorimage")
		dictionary.setValue(self.authorabout, forKey: "authorabout")

		return dictionary
	}

}
