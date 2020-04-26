/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Book {
	public var book_name : String?
	public var book_publish : String?
	public var book_pdf_url : String?
	public var author_Id : String?
    public var bookId : String?
	public var book_image_url : String?
	public var iD : String?
	public var name : String?
	public var about : String?
	public var image : String?
	public var categoryid : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Book]
    {
        var models:[Book] = []
        for item in array
        {
            models.append(Book(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Json4Swift_Base Instance.
*/
	required public init?(dictionary: NSDictionary) {
        bookId = dictionary["bookid"] as? String
		book_name = dictionary["book_name"] as? String
		book_publish = dictionary["book_publish"] as? String
		book_pdf_url = dictionary["book_pdf_url"] as? String
		author_Id = dictionary["author_Id"] as? String
		book_image_url = dictionary["book_image_url"] as? String
		iD = dictionary["ID"] as? String
		name = dictionary["Name"] as? String
		about = dictionary["about"] as? String
		image = dictionary["image"] as? String
		categoryid = dictionary["categoryid"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.book_name, forKey: "book_name")
		dictionary.setValue(self.book_publish, forKey: "book_publish")
		dictionary.setValue(self.book_pdf_url, forKey: "book_pdf_url")
		dictionary.setValue(self.author_Id, forKey: "author_Id")
		dictionary.setValue(self.book_image_url, forKey: "book_image_url")
		dictionary.setValue(self.iD, forKey: "ID")
		dictionary.setValue(self.name, forKey: "Name")
		dictionary.setValue(self.about, forKey: "about")
		dictionary.setValue(self.image, forKey: "image")
		dictionary.setValue(self.categoryid, forKey: "categoryid")
        dictionary.setValue(self.categoryid, forKey: "bookid")

		return dictionary
	}

}
