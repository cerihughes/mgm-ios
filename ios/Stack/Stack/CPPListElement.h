//
//  CPPListElement.h
//  Stack
//
//  Created by Home on 24/03/2014.
//  Copyright (c) 2014 cerihughes.co.uk. All rights reserved.
//

#ifndef __Stack__CPPListElement__
#define __Stack__CPPListElement__

namespace sip
{
    template <class T>
    class ListElement
    {
    public:
        ListElement(ListElement<T>* nextElement, T value)
        {
            _nextElement = nextElement;
            _value = value;
        }

        ListElement<T>* getListElement() {return _nextElement;};
        T getValue() {return _value;};

    private:
        ListElement<T>* _nextElement;
        T _value;
    };
};

#endif /* defined(__Stack__CPPListElement__) */
