//
//  CPPStack.h
//  Stack
//
//  Created by Home on 24/03/2014.
//  Copyright (c) 2014 cerihughes.co.uk. All rights reserved.
//

#ifndef __Stack__CPPStack__
#define __Stack__CPPStack__

#include "CPPListElement.h"

namespace sip
{
    template <class T>
    class Stack
    {
    public:
        bool push(T value);
        T pop();

    private:
        ListElement<T>* _head;
    };
};

#endif /* defined(__Stack__CPPStack__) */
