package uk.co.cerihughes.mgm.android.dataloader

import uk.co.cerihughes.mgm.android.model.Event

interface GCPService {
    fun getEvents(): List<Event>
}