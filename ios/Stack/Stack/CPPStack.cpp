//
//  CPPStack.cpp
//  Stack
//
//  Created by Home on 24/03/2014.
//  Copyright (c) 2014 cerihughes.co.uk. All rights reserved.
//

#include "CPPStack.h"

namespace sip
{
    template <class T>
    bool Stack<T>::push(T value)
    {
        _head = new ListElement<T>(_head, value);
    }

    template <class T>
    T Stack<T>::pop()
    {
        ListElement<T>* oldHead = _head;
        T value = oldHead->getValue();
        _head = oldHead->getNextElement();
        delete oldHead;
        return value;
    }
}