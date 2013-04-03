/*
 * $Id$
 *
 * Copyright 2012 by Sunbay Innovation Ltd.
 * 30 Turgeneva street, 95017 Simferopol, Ukraine.
 * All rights reserved.
 *
 * Author               Oleg Kutkov (oleg)
 * Creation date        10.07.2012
 */

#include <sys/kpi_mbuf.h>
#include <sys/systm.h>
#include <net/kpi_interface.h>
#include "pkt.h"
#include "logger.h"
#include "module_memory.h"

errno_t generate_mbuf(uio_t uio, u_int32_t mtu, mbuf_t *mbuf, void* prepend, size_t len, unsigned* total)
{
  mbuf_t first, mb;
	unsigned int mlen;
	unsigned int chunk_len;
	unsigned int copied = 0;
	errno_t error;
    
	if (!mbuf || !total) {
		return EFAULT;
	}
    
	if (uio_resid(uio) == 0) {
		log_err("no bytes to copy from\n");
		return EIO;
	}
    
	*total = 0;

	mbuf_gethdr(MBUF_WAITOK, MBUF_TYPE_DATA, &first);

	if (first == NULL) {
		log_err("could not get mbuf\n");
		return ENOMEM;
	}
    
	if (prepend && len) {
		memcpy(mbuf_data(first), prepend, len);
		mbuf_setlen(first, len);
		mlen = (unsigned int)mbuf_maxlen(first) - len;
	} else {
		mbuf_setlen(first, 0);
		mlen = (unsigned)mbuf_maxlen(first);
	}
    
	// stuff the data into the mbuf(s)
	mb = first;

	while (uio_resid(uio) > 0) {
		// copy a chunk. enforce mtu
		chunk_len = (unsigned)min(mtu, min(uio_resid(uio), mlen));
		error = uiomove((caddr_t) mbuf_data(mb)+mbuf_len(mb), chunk_len, uio);
		if (error) {
			log_err("could not copy data from userspace, %d\n", error);
			mbuf_freem(first);
			return error;
		}
        
		log_dbg("copied %d bytes, left %d bytes\n", chunk_len, uio_resid(uio));
        
		mlen -= chunk_len;
		mbuf_setlen(mb, mbuf_len(mb) + chunk_len);
		copied += chunk_len;
        
		// if done, break the loop
		if (uio_resid(uio) <= 0 || copied >= mtu) {
			break;
        }

		// allocate a new mbuf if the current is filled
		if (mlen == 0) {
			mbuf_t next;
			mbuf_get(MBUF_WAITOK, MBUF_TYPE_DATA, &next);

			if (next == NULL) {
				log_err("could not get mbuf\n");
				mbuf_freem(first);
				return ENOMEM;
			}

			mbuf_setnext(mb, next);
			mb = next;
			mbuf_setlen(mb, 0);
			mlen = (unsigned)mbuf_maxlen(mb);
		}
	}

	// fill in header info
	mbuf_pkthdr_setlen(first, copied);
	mbuf_pkthdr_setheader(first, mbuf_data(first));
	mbuf_set_csum_performed(first, 0, 0);
    
	*mbuf = first;
	*total = copied;

	return 0;
}

char* serialize_mbuf(mbuf_t m, size_t *len)
{
	char *pkt = NULL, *p = NULL;
	size_t pktlen = 0;
    
	if (!m) {
		log_err("Argument 'm' are NULL.\n");
		return NULL;
	}
    
	if (!len) {
		log_err("Argument 'len' are NULL.\n");
		return NULL;
	}
    
	pktlen = mbuf_pkthdr_len(m);
    
	pkt = p = OSMalloc(pktlen, moduleMallocTag);
	if (!pkt) {
		log_err("Memory allocation error!\n");
		return NULL;
	}

	// serialize mbuf's
	while (m) {
		memcpy(p, mbuf_data(m), mbuf_len(m));
		p += mbuf_len(m);
		m = mbuf_next(m);
	}
    
	if (p-pkt != pktlen) {
		log_dbg("Not all data copyed?\n");
	}
    
	*len = pktlen;
    
	return pkt;
}
