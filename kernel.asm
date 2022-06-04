
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 10 c6 10 80       	mov    $0x8010c610,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 90 35 10 80       	mov    $0x80103590,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb 54 c6 10 80       	mov    $0x8010c654,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 00 7b 10 80       	push   $0x80107b00
80100055:	68 20 c6 10 80       	push   $0x8010c620
8010005a:	e8 c1 4b 00 00       	call   80104c20 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 1c 0d 11 80       	mov    $0x80110d1c,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 6c 0d 11 80 1c 	movl   $0x80110d1c,0x80110d6c
8010006e:	0d 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 70 0d 11 80 1c 	movl   $0x80110d1c,0x80110d70
80100078:	0d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c 0d 11 80 	movl   $0x80110d1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 7b 10 80       	push   $0x80107b07
80100097:	50                   	push   %eax
80100098:	e8 43 4a 00 00       	call   80104ae0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 0d 11 80       	mov    0x80110d70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 0d 11 80    	mov    %ebx,0x80110d70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 0a 11 80    	cmp    $0x80110ac0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 20 c6 10 80       	push   $0x8010c620
801000e8:	e8 b3 4c 00 00       	call   80104da0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 70 0d 11 80    	mov    0x80110d70,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb 1c 0d 11 80    	cmp    $0x80110d1c,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c 0d 11 80    	cmp    $0x80110d1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c 0d 11 80    	mov    0x80110d6c,%ebx
80100126:	81 fb 1c 0d 11 80    	cmp    $0x80110d1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c 0d 11 80    	cmp    $0x80110d1c,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 c6 10 80       	push   $0x8010c620
80100162:	e8 f9 4c 00 00       	call   80104e60 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 49 00 00       	call   80104b20 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 3f 26 00 00       	call   801027d0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 0e 7b 10 80       	push   $0x80107b0e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 f9 49 00 00       	call   80104bc0 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 f3 25 00 00       	jmp    801027d0 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 1f 7b 10 80       	push   $0x80107b1f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 b8 49 00 00       	call   80104bc0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 68 49 00 00       	call   80104b80 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010021f:	e8 7c 4b 00 00       	call   80104da0 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 70 0d 11 80       	mov    0x80110d70,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 1c 0d 11 80 	movl   $0x80110d1c,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 70 0d 11 80       	mov    0x80110d70,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 70 0d 11 80    	mov    %ebx,0x80110d70
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 20 c6 10 80 	movl   $0x8010c620,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 eb 4b 00 00       	jmp    80104e60 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 26 7b 10 80       	push   $0x80107b26
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 e6 1a 00 00       	call   80101d90 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
801002b1:	e8 ea 4a 00 00       	call   80104da0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 00 10 11 80       	mov    0x80111000,%eax
801002cb:	3b 05 04 10 11 80    	cmp    0x80111004,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 40 b5 10 80       	push   $0x8010b540
801002e0:	68 00 10 11 80       	push   $0x80111000
801002e5:	e8 b6 41 00 00       	call   801044a0 <sleep>
    while(input.r == input.w){
801002ea:	a1 00 10 11 80       	mov    0x80111000,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 04 10 11 80    	cmp    0x80111004,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 e1 3b 00 00       	call   80103ee0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 40 b5 10 80       	push   $0x8010b540
8010030e:	e8 4d 4b 00 00       	call   80104e60 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 94 19 00 00       	call   80101cb0 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 00 10 11 80    	mov    %edx,0x80111000
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 80 0f 11 80 	movsbl -0x7feef080(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 40 b5 10 80       	push   $0x8010b540
80100365:	e8 f6 4a 00 00       	call   80104e60 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 3d 19 00 00       	call   80101cb0 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 00 10 11 80       	mov    %eax,0x80111000
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 74 b5 10 80 00 	movl   $0x0,0x8010b574
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 3e 2a 00 00       	call   80102df0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 2d 7b 10 80       	push   $0x80107b2d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 df 84 10 80 	movl   $0x801084df,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 5f 48 00 00       	call   80104c40 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 41 7b 10 80       	push   $0x80107b41
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 78 b5 10 80 01 	movl   $0x1,0x8010b578
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 d1 62 00 00       	call   80106700 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 e6 61 00 00       	call   80106700 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 da 61 00 00       	call   80106700 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 ce 61 00 00       	call   80106700 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 ea 49 00 00       	call   80104f50 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 35 49 00 00       	call   80104eb0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 45 7b 10 80       	push   $0x80107b45
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 70 7b 10 80 	movzbl -0x7fef8490(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 38 17 00 00       	call   80101d90 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010065f:	e8 3c 47 00 00       	call   80104da0 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 40 b5 10 80       	push   $0x8010b540
80100697:	e8 c4 47 00 00       	call   80104e60 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 0b 16 00 00       	call   80101cb0 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 74 b5 10 80       	mov    0x8010b574,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 78 b5 10 80    	mov    0x8010b578,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 58 7b 10 80       	mov    $0x80107b58,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 40 b5 10 80       	push   $0x8010b540
801007bd:	e8 de 45 00 00       	call   80104da0 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 78 b5 10 80    	mov    0x8010b578,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 78 b5 10 80    	mov    0x8010b578,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 40 b5 10 80       	push   $0x8010b540
80100828:	e8 33 46 00 00       	call   80104e60 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 5f 7b 10 80       	push   $0x80107b5f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <save_command>:
save_command(){      // save last command
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
  if(input.e - input.r > 1){
80100865:	8b 0d 00 10 11 80    	mov    0x80111000,%ecx
save_command(){      // save last command
8010086b:	89 e5                	mov    %esp,%ebp
8010086d:	57                   	push   %edi
8010086e:	56                   	push   %esi
8010086f:	53                   	push   %ebx
  if(input.e - input.r > 1){
80100870:	8b 1d 08 10 11 80    	mov    0x80111008,%ebx
80100876:	89 d8                	mov    %ebx,%eax
80100878:	29 c8                	sub    %ecx,%eax
8010087a:	83 f8 01             	cmp    $0x1,%eax
8010087d:	76 75                	jbe    801008f4 <save_command+0x94>
    for(int i=input.r; i < input.e-1 ; i++){
8010087f:	83 eb 01             	sub    $0x1,%ebx
  int last_index = saved_cmd.e%COMMAND_SAVED;
80100882:	8b 35 28 15 11 80    	mov    0x80111528,%esi
    for(int i=input.r; i < input.e-1 ; i++){
80100888:	39 d9                	cmp    %ebx,%ecx
8010088a:	73 49                	jae    801008d5 <save_command+0x75>
  int last_index = saved_cmd.e%COMMAND_SAVED;
8010088c:	89 f0                	mov    %esi,%eax
8010088e:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100893:	f7 e2                	mul    %edx
80100895:	c1 ea 03             	shr    $0x3,%edx
80100898:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010089b:	89 f2                	mov    %esi,%edx
8010089d:	01 c0                	add    %eax,%eax
8010089f:	29 c2                	sub    %eax,%edx
801008a1:	c1 e2 07             	shl    $0x7,%edx
801008a4:	29 ca                	sub    %ecx,%edx
801008a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801008ad:	8d 76 00             	lea    0x0(%esi),%esi
      saved_cmd.list[last_index][j] = input.buf[i%INPUT_BUF];
801008b0:	89 cf                	mov    %ecx,%edi
801008b2:	c1 ff 1f             	sar    $0x1f,%edi
801008b5:	c1 ef 19             	shr    $0x19,%edi
801008b8:	8d 04 39             	lea    (%ecx,%edi,1),%eax
801008bb:	83 e0 7f             	and    $0x7f,%eax
801008be:	29 f8                	sub    %edi,%eax
801008c0:	0f b6 80 80 0f 11 80 	movzbl -0x7feef080(%eax),%eax
801008c7:	88 84 0a 20 10 11 80 	mov    %al,-0x7feeefe0(%edx,%ecx,1)
    for(int i=input.r; i < input.e-1 ; i++){
801008ce:	83 c1 01             	add    $0x1,%ecx
801008d1:	39 d9                	cmp    %ebx,%ecx
801008d3:	72 db                	jb     801008b0 <save_command+0x50>
    if(saved_cmd.e == saved_cmd.s+COMMAND_SAVED)
801008d5:	a1 20 15 11 80       	mov    0x80111520,%eax
    saved_cmd.e++;
801008da:	83 c6 01             	add    $0x1,%esi
    saved_cmd.r = 0;
801008dd:	c7 05 24 15 11 80 00 	movl   $0x0,0x80111524
801008e4:	00 00 00 
    saved_cmd.e++;
801008e7:	89 35 28 15 11 80    	mov    %esi,0x80111528
    if(saved_cmd.e == saved_cmd.s+COMMAND_SAVED)
801008ed:	8d 50 0a             	lea    0xa(%eax),%edx
801008f0:	39 d6                	cmp    %edx,%esi
801008f2:	74 0c                	je     80100900 <save_command+0xa0>
}
801008f4:	5b                   	pop    %ebx
801008f5:	5e                   	pop    %esi
801008f6:	5f                   	pop    %edi
801008f7:	5d                   	pop    %ebp
801008f8:	c3                   	ret    
801008f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      saved_cmd.s++;   
80100900:	83 c0 01             	add    $0x1,%eax
}
80100903:	5b                   	pop    %ebx
80100904:	5e                   	pop    %esi
      saved_cmd.s++;   
80100905:	a3 20 15 11 80       	mov    %eax,0x80111520
}
8010090a:	5f                   	pop    %edi
8010090b:	5d                   	pop    %ebp
8010090c:	c3                   	ret    
8010090d:	8d 76 00             	lea    0x0(%esi),%esi

80100910 <show_last_command>:
show_last_command(){
80100910:	f3 0f 1e fb          	endbr32 
80100914:	55                   	push   %ebp
80100915:	89 e5                	mov    %esp,%ebp
80100917:	57                   	push   %edi
80100918:	56                   	push   %esi
80100919:	53                   	push   %ebx
8010091a:	83 ec 1c             	sub    $0x1c,%esp
  int buf_size = input.e - input.w;
8010091d:	a1 04 10 11 80       	mov    0x80111004,%eax
  char* cmd = saved_cmd.list[(saved_cmd.e-saved_cmd.r-1)%COMMAND_SAVED];
80100922:	8b 1d 28 15 11 80    	mov    0x80111528,%ebx
  if(saved_cmd.e - saved_cmd.s && saved_cmd.e-saved_cmd.s > saved_cmd.r){
80100928:	8b 15 20 15 11 80    	mov    0x80111520,%edx
  int buf_size = input.e - input.w;
8010092e:	8b 35 08 10 11 80    	mov    0x80111008,%esi
  char* cmd = saved_cmd.list[(saved_cmd.e-saved_cmd.r-1)%COMMAND_SAVED];
80100934:	8b 3d 24 15 11 80    	mov    0x80111524,%edi
  input.e = input.w;
8010093a:	a3 08 10 11 80       	mov    %eax,0x80111008
  if(saved_cmd.e - saved_cmd.s && saved_cmd.e-saved_cmd.s > saved_cmd.r){
8010093f:	39 d3                	cmp    %edx,%ebx
80100941:	74 24                	je     80100967 <show_last_command+0x57>
80100943:	89 d9                	mov    %ebx,%ecx
80100945:	29 d1                	sub    %edx,%ecx
80100947:	39 cf                	cmp    %ecx,%edi
80100949:	73 1c                	jae    80100967 <show_last_command+0x57>
  int buf_size = input.e - input.w;
8010094b:	29 c6                	sub    %eax,%esi
    for(int i=0; i<buf_size; i++)
8010094d:	85 f6                	test   %esi,%esi
8010094f:	7e 35                	jle    80100986 <show_last_command+0x76>
80100951:	31 d2                	xor    %edx,%edx
  if(panicked){
80100953:	8b 0d 78 b5 10 80    	mov    0x8010b578,%ecx
80100959:	85 c9                	test   %ecx,%ecx
8010095b:	74 12                	je     8010096f <show_last_command+0x5f>
8010095d:	fa                   	cli    
    for(;;)
8010095e:	eb fe                	jmp    8010095e <show_last_command+0x4e>
    saved_cmd.r++;
80100960:	83 05 24 15 11 80 01 	addl   $0x1,0x80111524
}
80100967:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010096a:	5b                   	pop    %ebx
8010096b:	5e                   	pop    %esi
8010096c:	5f                   	pop    %edi
8010096d:	5d                   	pop    %ebp
8010096e:	c3                   	ret    
8010096f:	b8 00 01 00 00       	mov    $0x100,%eax
80100974:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100977:	e8 94 fa ff ff       	call   80100410 <consputc.part.0>
    for(int i=0; i<buf_size; i++)
8010097c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010097f:	83 c2 01             	add    $0x1,%edx
80100982:	39 d6                	cmp    %edx,%esi
80100984:	75 cd                	jne    80100953 <show_last_command+0x43>
  char* cmd = saved_cmd.list[(saved_cmd.e-saved_cmd.r-1)%COMMAND_SAVED];
80100986:	8d 43 ff             	lea    -0x1(%ebx),%eax
80100989:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
    for(int i=0; i < strlen(cmd); i++){
8010098e:	31 f6                	xor    %esi,%esi
  char* cmd = saved_cmd.list[(saved_cmd.e-saved_cmd.r-1)%COMMAND_SAVED];
80100990:	29 f8                	sub    %edi,%eax
80100992:	89 c1                	mov    %eax,%ecx
80100994:	f7 e2                	mul    %edx
80100996:	89 d0                	mov    %edx,%eax
80100998:	c1 e8 03             	shr    $0x3,%eax
8010099b:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010099e:	01 c0                	add    %eax,%eax
801009a0:	29 c1                	sub    %eax,%ecx
801009a2:	89 c8                	mov    %ecx,%eax
801009a4:	c1 e0 07             	shl    $0x7,%eax
801009a7:	8d 98 20 10 11 80    	lea    -0x7feeefe0(%eax),%ebx
    for(int i=0; i < strlen(cmd); i++){
801009ad:	83 ec 0c             	sub    $0xc,%esp
801009b0:	53                   	push   %ebx
801009b1:	e8 fa 46 00 00       	call   801050b0 <strlen>
801009b6:	83 c4 10             	add    $0x10,%esp
801009b9:	39 f0                	cmp    %esi,%eax
801009bb:	7e a3                	jle    80100960 <show_last_command+0x50>
      input.buf[input.e++ % INPUT_BUF] = cmd[i];
801009bd:	8b 15 08 10 11 80    	mov    0x80111008,%edx
801009c3:	8d 42 01             	lea    0x1(%edx),%eax
801009c6:	83 e2 7f             	and    $0x7f,%edx
801009c9:	a3 08 10 11 80       	mov    %eax,0x80111008
801009ce:	0f be 04 33          	movsbl (%ebx,%esi,1),%eax
801009d2:	88 82 80 0f 11 80    	mov    %al,-0x7feef080(%edx)
  if(panicked){
801009d8:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
801009de:	85 d2                	test   %edx,%edx
801009e0:	74 06                	je     801009e8 <show_last_command+0xd8>
801009e2:	fa                   	cli    
    for(;;)
801009e3:	eb fe                	jmp    801009e3 <show_last_command+0xd3>
801009e5:	8d 76 00             	lea    0x0(%esi),%esi
801009e8:	e8 23 fa ff ff       	call   80100410 <consputc.part.0>
    for(int i=0; i < strlen(cmd); i++){
801009ed:	83 c6 01             	add    $0x1,%esi
801009f0:	eb bb                	jmp    801009ad <show_last_command+0x9d>
801009f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100a00 <move_cursor>:
move_cursor(int direction, int last_index){   // direction 0 for right 1 for left
80100a00:	f3 0f 1e fb          	endbr32 
80100a04:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100a05:	b8 0e 00 00 00       	mov    $0xe,%eax
80100a0a:	89 e5                	mov    %esp,%ebp
80100a0c:	57                   	push   %edi
80100a0d:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100a12:	56                   	push   %esi
80100a13:	89 fa                	mov    %edi,%edx
80100a15:	53                   	push   %ebx
80100a16:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100a17:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100a1c:	89 da                	mov    %ebx,%edx
80100a1e:	ec                   	in     (%dx),%al
  int pos = inb(CRTPORT+1) << 8;
80100a1f:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100a22:	89 fa                	mov    %edi,%edx
80100a24:	b8 0f 00 00 00       	mov    $0xf,%eax
80100a29:	89 ce                	mov    %ecx,%esi
80100a2b:	c1 e6 08             	shl    $0x8,%esi
80100a2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100a2f:	89 da                	mov    %ebx,%edx
80100a31:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100a32:	0f b6 c8             	movzbl %al,%ecx
80100a35:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100a3a:	09 f1                	or     %esi,%ecx
  if(direction){          // back
80100a3c:	89 c8                	mov    %ecx,%eax
80100a3e:	f7 e2                	mul    %edx
80100a40:	c1 ea 06             	shr    $0x6,%edx
80100a43:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100a46:	89 ca                	mov    %ecx,%edx
80100a48:	c1 e0 04             	shl    $0x4,%eax
80100a4b:	29 c2                	sub    %eax,%edx
80100a4d:	8b 45 08             	mov    0x8(%ebp),%eax
80100a50:	85 c0                	test   %eax,%eax
80100a52:	74 1c                	je     80100a70 <move_cursor+0x70>
    if(pos%80 > 2){
80100a54:	83 fa 02             	cmp    $0x2,%edx
80100a57:	7e 0d                	jle    80100a66 <move_cursor+0x66>
        input.e--;
80100a59:	83 2d 08 10 11 80 01 	subl   $0x1,0x80111008
        pos--;
80100a60:	8d 41 ff             	lea    -0x1(%ecx),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100a63:	89 da                	mov    %ebx,%edx
80100a65:	ee                   	out    %al,(%dx)
}
80100a66:	5b                   	pop    %ebx
80100a67:	5e                   	pop    %esi
80100a68:	5f                   	pop    %edi
80100a69:	5d                   	pop    %ebp
80100a6a:	c3                   	ret    
80100a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a6f:	90                   	nop
    if(pos%80 < 2+(last_index)){
80100a70:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a73:	83 c0 01             	add    $0x1,%eax
80100a76:	39 d0                	cmp    %edx,%eax
80100a78:	7c ec                	jl     80100a66 <move_cursor+0x66>
        input.e++;
80100a7a:	83 05 08 10 11 80 01 	addl   $0x1,0x80111008
        pos++;
80100a81:	8d 41 01             	lea    0x1(%ecx),%eax
80100a84:	89 da                	mov    %ebx,%edx
80100a86:	ee                   	out    %al,(%dx)
}
80100a87:	5b                   	pop    %ebx
80100a88:	5e                   	pop    %esi
80100a89:	5f                   	pop    %edi
80100a8a:	5d                   	pop    %ebp
80100a8b:	c3                   	ret    
80100a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100a90 <move_backward>:
move_backward(int last_index){        //movig all characters in buffer and CGA to the left
80100a90:	f3 0f 1e fb          	endbr32 
80100a94:	55                   	push   %ebp
80100a95:	b8 0e 00 00 00       	mov    $0xe,%eax
80100a9a:	89 e5                	mov    %esp,%ebp
80100a9c:	57                   	push   %edi
80100a9d:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100aa2:	56                   	push   %esi
80100aa3:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100aa6:	89 fa                	mov    %edi,%edx
80100aa8:	53                   	push   %ebx
80100aa9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100aaa:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100aaf:	89 da                	mov    %ebx,%edx
80100ab1:	ec                   	in     (%dx),%al
  int pos = inb(CRTPORT+1) << 8;
80100ab2:	0f b6 f0             	movzbl %al,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100ab5:	89 fa                	mov    %edi,%edx
80100ab7:	b8 0f 00 00 00       	mov    $0xf,%eax
80100abc:	c1 e6 08             	shl    $0x8,%esi
80100abf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100ac0:	89 da                	mov    %ebx,%edx
80100ac2:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100ac3:	0f b6 c0             	movzbl %al,%eax
80100ac6:	09 f0                	or     %esi,%eax
  for(int i=input.e-1;i<last_index;i++){
80100ac8:	8b 35 08 10 11 80    	mov    0x80111008,%esi
80100ace:	8d 5e ff             	lea    -0x1(%esi),%ebx
80100ad1:	39 cb                	cmp    %ecx,%ebx
80100ad3:	7d 4a                	jge    80100b1f <move_backward+0x8f>
80100ad5:	8d b4 00 00 80 0b 80 	lea    -0x7ff48000(%eax,%eax,1),%esi
80100adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    input.buf[i%INPUT_BUF] = input.buf[(i+1)%INPUT_BUF];   //Remove a char in middle
80100ae0:	89 d8                	mov    %ebx,%eax
80100ae2:	83 c3 01             	add    $0x1,%ebx
80100ae5:	83 c6 02             	add    $0x2,%esi
80100ae8:	89 df                	mov    %ebx,%edi
80100aea:	c1 ff 1f             	sar    $0x1f,%edi
80100aed:	c1 ef 19             	shr    $0x19,%edi
80100af0:	8d 14 3b             	lea    (%ebx,%edi,1),%edx
80100af3:	83 e2 7f             	and    $0x7f,%edx
80100af6:	29 fa                	sub    %edi,%edx
80100af8:	89 c7                	mov    %eax,%edi
80100afa:	c1 ff 1f             	sar    $0x1f,%edi
80100afd:	0f b6 92 80 0f 11 80 	movzbl -0x7feef080(%edx),%edx
80100b04:	c1 ef 19             	shr    $0x19,%edi
80100b07:	01 f8                	add    %edi,%eax
80100b09:	83 e0 7f             	and    $0x7f,%eax
80100b0c:	29 f8                	sub    %edi,%eax
80100b0e:	88 90 80 0f 11 80    	mov    %dl,-0x7feef080(%eax)
    crt[pos] = (input.buf[i%INPUT_BUF]&0xff) | 0x0700;    //Move all chars one left
80100b14:	80 ce 07             	or     $0x7,%dh
80100b17:	66 89 56 fe          	mov    %dx,-0x2(%esi)
  for(int i=input.e-1;i<last_index;i++){
80100b1b:	39 cb                	cmp    %ecx,%ebx
80100b1d:	7c c1                	jl     80100ae0 <move_backward+0x50>
}
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b2f:	90                   	nop

80100b30 <move_forward>:
move_forward(int last_index, char c){
80100b30:	f3 0f 1e fb          	endbr32 
80100b34:	55                   	push   %ebp
80100b35:	89 e5                	mov    %esp,%ebp
80100b37:	57                   	push   %edi
80100b38:	56                   	push   %esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b39:	be d4 03 00 00       	mov    $0x3d4,%esi
80100b3e:	53                   	push   %ebx
80100b3f:	89 f2                	mov    %esi,%edx
80100b41:	83 ec 04             	sub    $0x4,%esp
80100b44:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b47:	8b 7d 08             	mov    0x8(%ebp),%edi
80100b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100b4d:	b8 0e 00 00 00       	mov    $0xe,%eax
80100b52:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100b53:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100b58:	89 ca                	mov    %ecx,%edx
80100b5a:	ec                   	in     (%dx),%al
  int pos = inb(CRTPORT+1) << 8;
80100b5b:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b5e:	89 f2                	mov    %esi,%edx
80100b60:	b8 0f 00 00 00       	mov    $0xf,%eax
80100b65:	c1 e3 08             	shl    $0x8,%ebx
80100b68:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100b69:	89 ca                	mov    %ecx,%edx
80100b6b:	ec                   	in     (%dx),%al
  pos += 1+last_index-input.e;
80100b6c:	8b 35 08 10 11 80    	mov    0x80111008,%esi
80100b72:	89 fa                	mov    %edi,%edx
  pos |= inb(CRTPORT+1);
80100b74:	0f b6 c0             	movzbl %al,%eax
80100b77:	09 c3                	or     %eax,%ebx
  pos += 1+last_index-input.e;
80100b79:	29 f2                	sub    %esi,%edx
80100b7b:	8d 4c 1a 01          	lea    0x1(%edx,%ebx,1),%ecx
  for(int i=last_index+1;i > input.e;i--){
80100b7f:	8d 57 01             	lea    0x1(%edi),%edx
80100b82:	39 d6                	cmp    %edx,%esi
80100b84:	0f 83 8e 00 00 00    	jae    80100c18 <move_forward+0xe8>
80100b8a:	f7 d7                	not    %edi
80100b8c:	8d b4 09 00 80 0b 80 	lea    -0x7ff48000(%ecx,%ecx,1),%esi
80100b93:	01 cf                	add    %ecx,%edi
80100b95:	8d 76 00             	lea    0x0(%esi),%esi
    input.buf[i%INPUT_BUF] = input.buf[(i-1)%INPUT_BUF];
80100b98:	89 d0                	mov    %edx,%eax
80100b9a:	83 ea 01             	sub    $0x1,%edx
80100b9d:	83 ee 02             	sub    $0x2,%esi
80100ba0:	89 d3                	mov    %edx,%ebx
80100ba2:	c1 fb 1f             	sar    $0x1f,%ebx
80100ba5:	c1 eb 19             	shr    $0x19,%ebx
80100ba8:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80100bab:	83 e1 7f             	and    $0x7f,%ecx
80100bae:	29 d9                	sub    %ebx,%ecx
80100bb0:	89 c3                	mov    %eax,%ebx
80100bb2:	c1 fb 1f             	sar    $0x1f,%ebx
80100bb5:	0f b6 89 80 0f 11 80 	movzbl -0x7feef080(%ecx),%ecx
80100bbc:	c1 eb 19             	shr    $0x19,%ebx
80100bbf:	01 d8                	add    %ebx,%eax
80100bc1:	83 e0 7f             	and    $0x7f,%eax
80100bc4:	29 d8                	sub    %ebx,%eax
80100bc6:	88 88 80 0f 11 80    	mov    %cl,-0x7feef080(%eax)
    crt[pos] = (input.buf[i%INPUT_BUF]&0xff) | 0x0700;
80100bcc:	80 cd 07             	or     $0x7,%ch
80100bcf:	66 89 4e 02          	mov    %cx,0x2(%esi)
    pos--;
80100bd3:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
80100bd6:	89 c8                	mov    %ecx,%eax
  for(int i=last_index+1;i > input.e;i--){
80100bd8:	39 15 08 10 11 80    	cmp    %edx,0x80111008
80100bde:	72 b8                	jb     80100b98 <move_forward+0x68>
  crt[pos] = (c&0xff) | 0x0700;
80100be0:	8b 7d f0             	mov    -0x10(%ebp),%edi
80100be3:	89 fa                	mov    %edi,%edx
  input.buf[input.e%INPUT_BUF] = c;
80100be5:	89 fb                	mov    %edi,%ebx
  crt[pos] = (c&0xff) | 0x0700;
80100be7:	0f b6 d2             	movzbl %dl,%edx
80100bea:	80 ce 07             	or     $0x7,%dh
80100bed:	66 89 94 09 00 80 0b 	mov    %dx,-0x7ff48000(%ecx,%ecx,1)
80100bf4:	80 
  input.buf[input.e%INPUT_BUF] = c;
80100bf5:	8b 15 08 10 11 80    	mov    0x80111008,%edx
80100bfb:	83 e2 7f             	and    $0x7f,%edx
80100bfe:	88 9a 80 0f 11 80    	mov    %bl,-0x7feef080(%edx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c04:	ba d5 03 00 00       	mov    $0x3d5,%edx
80100c09:	ee                   	out    %al,(%dx)
}
80100c0a:	83 c4 04             	add    $0x4,%esp
80100c0d:	5b                   	pop    %ebx
80100c0e:	5e                   	pop    %esi
80100c0f:	5f                   	pop    %edi
80100c10:	5d                   	pop    %ebp
80100c11:	c3                   	ret    
80100c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100c18:	89 c8                	mov    %ecx,%eax
80100c1a:	eb c4                	jmp    80100be0 <move_forward+0xb0>
80100c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100c20 <consoleintr>:
{
80100c20:	f3 0f 1e fb          	endbr32 
80100c24:	55                   	push   %ebp
80100c25:	89 e5                	mov    %esp,%ebp
80100c27:	57                   	push   %edi
80100c28:	56                   	push   %esi
80100c29:	53                   	push   %ebx
  int c, doprocdump = 0;
80100c2a:	31 db                	xor    %ebx,%ebx
80100c2c:	89 df                	mov    %ebx,%edi
{
80100c2e:	83 ec 28             	sub    $0x28,%esp
80100c31:	8b 45 08             	mov    0x8(%ebp),%eax
  acquire(&cons.lock);
80100c34:	68 40 b5 10 80       	push   $0x8010b540
{
80100c39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  acquire(&cons.lock);
80100c3c:	e8 5f 41 00 00       	call   80104da0 <acquire>
  while((c = getc()) >= 0){
80100c41:	83 c4 10             	add    $0x10,%esp
80100c44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100c47:	ff d0                	call   *%eax
80100c49:	89 c3                	mov    %eax,%ebx
80100c4b:	85 c0                	test   %eax,%eax
80100c4d:	0f 88 96 00 00 00    	js     80100ce9 <consoleintr+0xc9>
    switch(c){
80100c53:	83 fb 7f             	cmp    $0x7f,%ebx
80100c56:	0f 84 0d 01 00 00    	je     80100d69 <consoleintr+0x149>
80100c5c:	0f 8e ae 00 00 00    	jle    80100d10 <consoleintr+0xf0>
80100c62:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
80100c68:	0f 84 5b 01 00 00    	je     80100dc9 <consoleintr+0x1a9>
80100c6e:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
80100c74:	0f 85 16 01 00 00    	jne    80100d90 <consoleintr+0x170>
80100c7a:	be d4 03 00 00       	mov    $0x3d4,%esi
80100c7f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100c84:	89 f2                	mov    %esi,%edx
80100c86:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c87:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100c8c:	89 da                	mov    %ebx,%edx
80100c8e:	ec                   	in     (%dx),%al
80100c8f:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c92:	89 f2                	mov    %esi,%edx
80100c94:	b8 0f 00 00 00       	mov    $0xf,%eax
  int pos = inb(CRTPORT+1) << 8;
80100c99:	c1 e1 08             	shl    $0x8,%ecx
80100c9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c9d:	89 da                	mov    %ebx,%edx
80100c9f:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100ca0:	0f b6 c0             	movzbl %al,%eax
    if(pos%80 < 2+(last_index)){
80100ca3:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  pos |= inb(CRTPORT+1);
80100ca8:	09 c1                	or     %eax,%ecx
    if(pos%80 < 2+(last_index)){
80100caa:	a1 20 b5 10 80       	mov    0x8010b520,%eax
80100caf:	8d 70 01             	lea    0x1(%eax),%esi
80100cb2:	89 c8                	mov    %ecx,%eax
80100cb4:	f7 e2                	mul    %edx
80100cb6:	89 d0                	mov    %edx,%eax
80100cb8:	89 ca                	mov    %ecx,%edx
80100cba:	c1 e8 06             	shr    $0x6,%eax
80100cbd:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100cc0:	c1 e0 04             	shl    $0x4,%eax
80100cc3:	29 c2                	sub    %eax,%edx
80100cc5:	39 d6                	cmp    %edx,%esi
80100cc7:	0f 8c 77 ff ff ff    	jl     80100c44 <consoleintr+0x24>
        input.e++;
80100ccd:	83 05 08 10 11 80 01 	addl   $0x1,0x80111008
        pos++;
80100cd4:	8d 41 01             	lea    0x1(%ecx),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100cd7:	89 da                	mov    %ebx,%edx
80100cd9:	ee                   	out    %al,(%dx)
  while((c = getc()) >= 0){
80100cda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cdd:	ff d0                	call   *%eax
80100cdf:	89 c3                	mov    %eax,%ebx
80100ce1:	85 c0                	test   %eax,%eax
80100ce3:	0f 89 6a ff ff ff    	jns    80100c53 <consoleintr+0x33>
  release(&cons.lock);
80100ce9:	83 ec 0c             	sub    $0xc,%esp
80100cec:	68 40 b5 10 80       	push   $0x8010b540
80100cf1:	e8 6a 41 00 00       	call   80104e60 <release>
  if(doprocdump) {
80100cf6:	83 c4 10             	add    $0x10,%esp
80100cf9:	85 ff                	test   %edi,%edi
80100cfb:	0f 85 5b 02 00 00    	jne    80100f5c <consoleintr+0x33c>
}
80100d01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d04:	5b                   	pop    %ebx
80100d05:	5e                   	pop    %esi
80100d06:	5f                   	pop    %edi
80100d07:	5d                   	pop    %ebp
80100d08:	c3                   	ret    
80100d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100d10:	83 fb 10             	cmp    $0x10,%ebx
80100d13:	0f 84 97 00 00 00    	je     80100db0 <consoleintr+0x190>
80100d19:	83 fb 15             	cmp    $0x15,%ebx
80100d1c:	75 42                	jne    80100d60 <consoleintr+0x140>
      while(input.e != input.w &&
80100d1e:	a1 08 10 11 80       	mov    0x80111008,%eax
80100d23:	3b 05 04 10 11 80    	cmp    0x80111004,%eax
80100d29:	0f 84 15 ff ff ff    	je     80100c44 <consoleintr+0x24>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100d2f:	83 e8 01             	sub    $0x1,%eax
80100d32:	89 c2                	mov    %eax,%edx
80100d34:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100d37:	80 ba 80 0f 11 80 0a 	cmpb   $0xa,-0x7feef080(%edx)
80100d3e:	0f 84 00 ff ff ff    	je     80100c44 <consoleintr+0x24>
  if(panicked){
80100d44:	8b 0d 78 b5 10 80    	mov    0x8010b578,%ecx
        input.e--;
80100d4a:	a3 08 10 11 80       	mov    %eax,0x80111008
  if(panicked){
80100d4f:	85 c9                	test   %ecx,%ecx
80100d51:	74 67                	je     80100dba <consoleintr+0x19a>
  asm volatile("cli");
80100d53:	fa                   	cli    
    for(;;)
80100d54:	eb fe                	jmp    80100d54 <consoleintr+0x134>
80100d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d5d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100d60:	83 fb 08             	cmp    $0x8,%ebx
80100d63:	0f 85 be 00 00 00    	jne    80100e27 <consoleintr+0x207>
      if(input.e != input.w){
80100d69:	a1 04 10 11 80       	mov    0x80111004,%eax
80100d6e:	39 05 08 10 11 80    	cmp    %eax,0x80111008
80100d74:	0f 84 ca fe ff ff    	je     80100c44 <consoleintr+0x24>
  if(panicked){
80100d7a:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
80100d80:	85 d2                	test   %edx,%edx
80100d82:	0f 84 f8 00 00 00    	je     80100e80 <consoleintr+0x260>
80100d88:	fa                   	cli    
    for(;;)
80100d89:	eb fe                	jmp    80100d89 <consoleintr+0x169>
80100d8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100d8f:	90                   	nop
    switch(c){
80100d90:	81 fb e2 00 00 00    	cmp    $0xe2,%ebx
80100d96:	0f 85 93 00 00 00    	jne    80100e2f <consoleintr+0x20f>
      show_last_command();
80100d9c:	e8 6f fb ff ff       	call   80100910 <show_last_command>
      last_index = input.e;
80100da1:	a1 08 10 11 80       	mov    0x80111008,%eax
80100da6:	a3 20 b5 10 80       	mov    %eax,0x8010b520
      break;
80100dab:	e9 94 fe ff ff       	jmp    80100c44 <consoleintr+0x24>
    switch(c){
80100db0:	bf 01 00 00 00       	mov    $0x1,%edi
80100db5:	e9 8a fe ff ff       	jmp    80100c44 <consoleintr+0x24>
80100dba:	b8 00 01 00 00       	mov    $0x100,%eax
80100dbf:	e8 4c f6 ff ff       	call   80100410 <consputc.part.0>
80100dc4:	e9 55 ff ff ff       	jmp    80100d1e <consoleintr+0xfe>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100dc9:	be d4 03 00 00       	mov    $0x3d4,%esi
80100dce:	b8 0e 00 00 00       	mov    $0xe,%eax
80100dd3:	89 f2                	mov    %esi,%edx
80100dd5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100dd6:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100ddb:	89 da                	mov    %ebx,%edx
80100ddd:	ec                   	in     (%dx),%al
80100dde:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100de1:	89 f2                	mov    %esi,%edx
80100de3:	b8 0f 00 00 00       	mov    $0xf,%eax
  int pos = inb(CRTPORT+1) << 8;
80100de8:	c1 e1 08             	shl    $0x8,%ecx
80100deb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100dec:	89 da                	mov    %ebx,%edx
80100dee:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100def:	0f b6 c0             	movzbl %al,%eax
    if(pos%80 > 2){
80100df2:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  pos |= inb(CRTPORT+1);
80100df7:	09 c1                	or     %eax,%ecx
    if(pos%80 > 2){
80100df9:	89 c8                	mov    %ecx,%eax
80100dfb:	89 ce                	mov    %ecx,%esi
80100dfd:	f7 e2                	mul    %edx
80100dff:	89 d0                	mov    %edx,%eax
80100e01:	c1 e8 06             	shr    $0x6,%eax
80100e04:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100e07:	c1 e0 04             	shl    $0x4,%eax
80100e0a:	29 c6                	sub    %eax,%esi
80100e0c:	83 fe 02             	cmp    $0x2,%esi
80100e0f:	0f 8e 2f fe ff ff    	jle    80100c44 <consoleintr+0x24>
        input.e--;
80100e15:	83 2d 08 10 11 80 01 	subl   $0x1,0x80111008
        pos--;
80100e1c:	8d 41 ff             	lea    -0x1(%ecx),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100e1f:	89 da                	mov    %ebx,%edx
80100e21:	ee                   	out    %al,(%dx)
}
80100e22:	e9 1d fe ff ff       	jmp    80100c44 <consoleintr+0x24>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100e27:	85 db                	test   %ebx,%ebx
80100e29:	0f 84 15 fe ff ff    	je     80100c44 <consoleintr+0x24>
80100e2f:	a1 08 10 11 80       	mov    0x80111008,%eax
80100e34:	89 c2                	mov    %eax,%edx
80100e36:	2b 15 00 10 11 80    	sub    0x80111000,%edx
80100e3c:	83 fa 7f             	cmp    $0x7f,%edx
80100e3f:	0f 87 ff fd ff ff    	ja     80100c44 <consoleintr+0x24>
        c = (c == '\r') ? '\n' : c;
80100e45:	89 c2                	mov    %eax,%edx
80100e47:	83 e2 7f             	and    $0x7f,%edx
80100e4a:	0f b6 b2 80 0f 11 80 	movzbl -0x7feef080(%edx),%esi
80100e51:	83 fb 0d             	cmp    $0xd,%ebx
80100e54:	0f 84 f8 00 00 00    	je     80100f52 <consoleintr+0x332>
        if(c != '\n')
80100e5a:	83 fb 0a             	cmp    $0xa,%ebx
80100e5d:	74 0e                	je     80100e6d <consoleintr+0x24d>
          input.buf[input.e++ % INPUT_BUF] = c;
80100e5f:	83 c0 01             	add    $0x1,%eax
80100e62:	88 9a 80 0f 11 80    	mov    %bl,-0x7feef080(%edx)
80100e68:	a3 08 10 11 80       	mov    %eax,0x80111008
  if(panicked){
80100e6d:	a1 78 b5 10 80       	mov    0x8010b578,%eax
80100e72:	85 c0                	test   %eax,%eax
80100e74:	74 3b                	je     80100eb1 <consoleintr+0x291>
  asm volatile("cli");
80100e76:	fa                   	cli    
    for(;;)
80100e77:	eb fe                	jmp    80100e77 <consoleintr+0x257>
80100e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e80:	b8 00 01 00 00       	mov    $0x100,%eax
80100e85:	e8 86 f5 ff ff       	call   80100410 <consputc.part.0>
        move_backward(last_index);
80100e8a:	8b 1d 20 b5 10 80    	mov    0x8010b520,%ebx
80100e90:	83 ec 0c             	sub    $0xc,%esp
80100e93:	53                   	push   %ebx
        last_index--;
80100e94:	83 eb 01             	sub    $0x1,%ebx
        move_backward(last_index);
80100e97:	e8 f4 fb ff ff       	call   80100a90 <move_backward>
        input.e--;
80100e9c:	83 2d 08 10 11 80 01 	subl   $0x1,0x80111008
        last_index--;
80100ea3:	83 c4 10             	add    $0x10,%esp
80100ea6:	89 1d 20 b5 10 80    	mov    %ebx,0x8010b520
80100eac:	e9 93 fd ff ff       	jmp    80100c44 <consoleintr+0x24>
80100eb1:	89 d8                	mov    %ebx,%eax
80100eb3:	e8 58 f5 ff ff       	call   80100410 <consputc.part.0>
        if(last_index > input.e && c != '\n'){
80100eb8:	8b 15 08 10 11 80    	mov    0x80111008,%edx
80100ebe:	a1 20 b5 10 80       	mov    0x8010b520,%eax
80100ec3:	39 c2                	cmp    %eax,%edx
80100ec5:	0f 83 9d 00 00 00    	jae    80100f68 <consoleintr+0x348>
80100ecb:	83 fb 0a             	cmp    $0xa,%ebx
80100ece:	74 43                	je     80100f13 <consoleintr+0x2f3>
          move_forward(last_index, temp);
80100ed0:	89 f1                	mov    %esi,%ecx
80100ed2:	83 ec 08             	sub    $0x8,%esp
80100ed5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100ed8:	0f be f1             	movsbl %cl,%esi
80100edb:	56                   	push   %esi
80100edc:	50                   	push   %eax
80100edd:	e8 4e fc ff ff       	call   80100b30 <move_forward>
          last_index++;
80100ee2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ee5:	83 c4 10             	add    $0x10,%esp
80100ee8:	83 c0 01             	add    $0x1,%eax
80100eeb:	a3 20 b5 10 80       	mov    %eax,0x8010b520
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100ef0:	83 fb 0a             	cmp    $0xa,%ebx
80100ef3:	74 19                	je     80100f0e <consoleintr+0x2ee>
80100ef5:	83 fb 04             	cmp    $0x4,%ebx
80100ef8:	74 14                	je     80100f0e <consoleintr+0x2ee>
80100efa:	a1 00 10 11 80       	mov    0x80111000,%eax
80100eff:	83 e8 80             	sub    $0xffffff80,%eax
80100f02:	39 05 08 10 11 80    	cmp    %eax,0x80111008
80100f08:	0f 85 36 fd ff ff    	jne    80100c44 <consoleintr+0x24>
80100f0e:	a1 20 b5 10 80       	mov    0x8010b520,%eax
          input.e = ++last_index;
80100f13:	8d 50 01             	lea    0x1(%eax),%edx
          input.buf[input.e++ % INPUT_BUF] = '\n';
80100f16:	83 c0 02             	add    $0x2,%eax
          input.e = ++last_index;
80100f19:	89 15 20 b5 10 80    	mov    %edx,0x8010b520
          input.buf[input.e++ % INPUT_BUF] = '\n';
80100f1f:	83 e2 7f             	and    $0x7f,%edx
80100f22:	a3 08 10 11 80       	mov    %eax,0x80111008
80100f27:	c6 82 80 0f 11 80 0a 	movb   $0xa,-0x7feef080(%edx)
          save_command();
80100f2e:	e8 2d f9 ff ff       	call   80100860 <save_command>
          wakeup(&input.r);
80100f33:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100f36:	a1 08 10 11 80       	mov    0x80111008,%eax
          wakeup(&input.r);
80100f3b:	68 00 10 11 80       	push   $0x80111000
          input.w = input.e;
80100f40:	a3 04 10 11 80       	mov    %eax,0x80111004
          wakeup(&input.r);
80100f45:	e8 16 37 00 00       	call   80104660 <wakeup>
80100f4a:	83 c4 10             	add    $0x10,%esp
80100f4d:	e9 f2 fc ff ff       	jmp    80100c44 <consoleintr+0x24>
        c = (c == '\r') ? '\n' : c;
80100f52:	bb 0a 00 00 00       	mov    $0xa,%ebx
80100f57:	e9 11 ff ff ff       	jmp    80100e6d <consoleintr+0x24d>
}
80100f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5f:	5b                   	pop    %ebx
80100f60:	5e                   	pop    %esi
80100f61:	5f                   	pop    %edi
80100f62:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100f63:	e9 f8 37 00 00       	jmp    80104760 <procdump>
        else if(last_index < input.e)
80100f68:	76 86                	jbe    80100ef0 <consoleintr+0x2d0>
          last_index = input.e;
80100f6a:	89 15 20 b5 10 80    	mov    %edx,0x8010b520
80100f70:	e9 7b ff ff ff       	jmp    80100ef0 <consoleintr+0x2d0>
80100f75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f80 <consoleinit>:

void
consoleinit(void)
{
80100f80:	f3 0f 1e fb          	endbr32 
80100f84:	55                   	push   %ebp
80100f85:	89 e5                	mov    %esp,%ebp
80100f87:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100f8a:	68 68 7b 10 80       	push   $0x80107b68
80100f8f:	68 40 b5 10 80       	push   $0x8010b540
80100f94:	e8 87 3c 00 00       	call   80104c20 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100f99:	58                   	pop    %eax
80100f9a:	5a                   	pop    %edx
80100f9b:	6a 00                	push   $0x0
80100f9d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100f9f:	c7 05 ec 1e 11 80 40 	movl   $0x80100640,0x80111eec
80100fa6:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100fa9:	c7 05 e8 1e 11 80 90 	movl   $0x80100290,0x80111ee8
80100fb0:	02 10 80 
  cons.locking = 1;
80100fb3:	c7 05 74 b5 10 80 01 	movl   $0x1,0x8010b574
80100fba:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100fbd:	e8 be 19 00 00       	call   80102980 <ioapicenable>
}
80100fc2:	83 c4 10             	add    $0x10,%esp
80100fc5:	c9                   	leave  
80100fc6:	c3                   	ret    
80100fc7:	66 90                	xchg   %ax,%ax
80100fc9:	66 90                	xchg   %ax,%ax
80100fcb:	66 90                	xchg   %ax,%ax
80100fcd:	66 90                	xchg   %ax,%ax
80100fcf:	90                   	nop

80100fd0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100fd0:	f3 0f 1e fb          	endbr32 
80100fd4:	55                   	push   %ebp
80100fd5:	89 e5                	mov    %esp,%ebp
80100fd7:	57                   	push   %edi
80100fd8:	56                   	push   %esi
80100fd9:	53                   	push   %ebx
80100fda:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100fe0:	e8 fb 2e 00 00       	call   80103ee0 <myproc>
80100fe5:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100feb:	e8 90 22 00 00       	call   80103280 <begin_op>

  if((ip = namei(path)) == 0){
80100ff0:	83 ec 0c             	sub    $0xc,%esp
80100ff3:	ff 75 08             	pushl  0x8(%ebp)
80100ff6:	e8 85 15 00 00       	call   80102580 <namei>
80100ffb:	83 c4 10             	add    $0x10,%esp
80100ffe:	85 c0                	test   %eax,%eax
80101000:	0f 84 fe 02 00 00    	je     80101304 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101006:	83 ec 0c             	sub    $0xc,%esp
80101009:	89 c3                	mov    %eax,%ebx
8010100b:	50                   	push   %eax
8010100c:	e8 9f 0c 00 00       	call   80101cb0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80101011:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101017:	6a 34                	push   $0x34
80101019:	6a 00                	push   $0x0
8010101b:	50                   	push   %eax
8010101c:	53                   	push   %ebx
8010101d:	e8 8e 0f 00 00       	call   80101fb0 <readi>
80101022:	83 c4 20             	add    $0x20,%esp
80101025:	83 f8 34             	cmp    $0x34,%eax
80101028:	74 26                	je     80101050 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
8010102a:	83 ec 0c             	sub    $0xc,%esp
8010102d:	53                   	push   %ebx
8010102e:	e8 1d 0f 00 00       	call   80101f50 <iunlockput>
    end_op();
80101033:	e8 b8 22 00 00       	call   801032f0 <end_op>
80101038:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
8010103b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101040:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101043:	5b                   	pop    %ebx
80101044:	5e                   	pop    %esi
80101045:	5f                   	pop    %edi
80101046:	5d                   	pop    %ebp
80101047:	c3                   	ret    
80101048:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010104f:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80101050:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80101057:	45 4c 46 
8010105a:	75 ce                	jne    8010102a <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
8010105c:	e8 0f 68 00 00       	call   80107870 <setupkvm>
80101061:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80101067:	85 c0                	test   %eax,%eax
80101069:	74 bf                	je     8010102a <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010106b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101072:	00 
80101073:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80101079:	0f 84 a4 02 00 00    	je     80101323 <exec+0x353>
  sz = 0;
8010107f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101086:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101089:	31 ff                	xor    %edi,%edi
8010108b:	e9 86 00 00 00       	jmp    80101116 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80101090:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80101097:	75 6c                	jne    80101105 <exec+0x135>
    if(ph.memsz < ph.filesz)
80101099:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
8010109f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801010a5:	0f 82 87 00 00 00    	jb     80101132 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
801010ab:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801010b1:	72 7f                	jb     80101132 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801010b3:	83 ec 04             	sub    $0x4,%esp
801010b6:	50                   	push   %eax
801010b7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
801010bd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801010c3:	e8 c8 65 00 00       	call   80107690 <allocuvm>
801010c8:	83 c4 10             	add    $0x10,%esp
801010cb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801010d1:	85 c0                	test   %eax,%eax
801010d3:	74 5d                	je     80101132 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
801010d5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
801010db:	a9 ff 0f 00 00       	test   $0xfff,%eax
801010e0:	75 50                	jne    80101132 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
801010e2:	83 ec 0c             	sub    $0xc,%esp
801010e5:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
801010eb:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
801010f1:	53                   	push   %ebx
801010f2:	50                   	push   %eax
801010f3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801010f9:	e8 c2 64 00 00       	call   801075c0 <loaduvm>
801010fe:	83 c4 20             	add    $0x20,%esp
80101101:	85 c0                	test   %eax,%eax
80101103:	78 2d                	js     80101132 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101105:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
8010110c:	83 c7 01             	add    $0x1,%edi
8010110f:	83 c6 20             	add    $0x20,%esi
80101112:	39 f8                	cmp    %edi,%eax
80101114:	7e 3a                	jle    80101150 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101116:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
8010111c:	6a 20                	push   $0x20
8010111e:	56                   	push   %esi
8010111f:	50                   	push   %eax
80101120:	53                   	push   %ebx
80101121:	e8 8a 0e 00 00       	call   80101fb0 <readi>
80101126:	83 c4 10             	add    $0x10,%esp
80101129:	83 f8 20             	cmp    $0x20,%eax
8010112c:	0f 84 5e ff ff ff    	je     80101090 <exec+0xc0>
    freevm(pgdir);
80101132:	83 ec 0c             	sub    $0xc,%esp
80101135:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
8010113b:	e8 b0 66 00 00       	call   801077f0 <freevm>
  if(ip){
80101140:	83 c4 10             	add    $0x10,%esp
80101143:	e9 e2 fe ff ff       	jmp    8010102a <exec+0x5a>
80101148:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010114f:	90                   	nop
80101150:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80101156:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
8010115c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80101162:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80101168:	83 ec 0c             	sub    $0xc,%esp
8010116b:	53                   	push   %ebx
8010116c:	e8 df 0d 00 00       	call   80101f50 <iunlockput>
  end_op();
80101171:	e8 7a 21 00 00       	call   801032f0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101176:	83 c4 0c             	add    $0xc,%esp
80101179:	56                   	push   %esi
8010117a:	57                   	push   %edi
8010117b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80101181:	57                   	push   %edi
80101182:	e8 09 65 00 00       	call   80107690 <allocuvm>
80101187:	83 c4 10             	add    $0x10,%esp
8010118a:	89 c6                	mov    %eax,%esi
8010118c:	85 c0                	test   %eax,%eax
8010118e:	0f 84 94 00 00 00    	je     80101228 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101194:	83 ec 08             	sub    $0x8,%esp
80101197:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
8010119d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010119f:	50                   	push   %eax
801011a0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
801011a1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801011a3:	e8 68 67 00 00       	call   80107910 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
801011a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801011ab:	83 c4 10             	add    $0x10,%esp
801011ae:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
801011b4:	8b 00                	mov    (%eax),%eax
801011b6:	85 c0                	test   %eax,%eax
801011b8:	0f 84 8b 00 00 00    	je     80101249 <exec+0x279>
801011be:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
801011c4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
801011ca:	eb 23                	jmp    801011ef <exec+0x21f>
801011cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011d0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
801011d3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
801011da:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
801011dd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
801011e3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
801011e6:	85 c0                	test   %eax,%eax
801011e8:	74 59                	je     80101243 <exec+0x273>
    if(argc >= MAXARG)
801011ea:	83 ff 20             	cmp    $0x20,%edi
801011ed:	74 39                	je     80101228 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801011ef:	83 ec 0c             	sub    $0xc,%esp
801011f2:	50                   	push   %eax
801011f3:	e8 b8 3e 00 00       	call   801050b0 <strlen>
801011f8:	f7 d0                	not    %eax
801011fa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801011fc:	58                   	pop    %eax
801011fd:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101200:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101203:	ff 34 b8             	pushl  (%eax,%edi,4)
80101206:	e8 a5 3e 00 00       	call   801050b0 <strlen>
8010120b:	83 c0 01             	add    $0x1,%eax
8010120e:	50                   	push   %eax
8010120f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101212:	ff 34 b8             	pushl  (%eax,%edi,4)
80101215:	53                   	push   %ebx
80101216:	56                   	push   %esi
80101217:	e8 54 68 00 00       	call   80107a70 <copyout>
8010121c:	83 c4 20             	add    $0x20,%esp
8010121f:	85 c0                	test   %eax,%eax
80101221:	79 ad                	jns    801011d0 <exec+0x200>
80101223:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101227:	90                   	nop
    freevm(pgdir);
80101228:	83 ec 0c             	sub    $0xc,%esp
8010122b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101231:	e8 ba 65 00 00       	call   801077f0 <freevm>
80101236:	83 c4 10             	add    $0x10,%esp
  return -1;
80101239:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010123e:	e9 fd fd ff ff       	jmp    80101040 <exec+0x70>
80101243:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101249:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101250:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80101252:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101259:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010125d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
8010125f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80101262:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80101268:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010126a:	50                   	push   %eax
8010126b:	52                   	push   %edx
8010126c:	53                   	push   %ebx
8010126d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80101273:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010127a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010127d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101283:	e8 e8 67 00 00       	call   80107a70 <copyout>
80101288:	83 c4 10             	add    $0x10,%esp
8010128b:	85 c0                	test   %eax,%eax
8010128d:	78 99                	js     80101228 <exec+0x258>
  for(last=s=path; *s; s++)
8010128f:	8b 45 08             	mov    0x8(%ebp),%eax
80101292:	8b 55 08             	mov    0x8(%ebp),%edx
80101295:	0f b6 00             	movzbl (%eax),%eax
80101298:	84 c0                	test   %al,%al
8010129a:	74 13                	je     801012af <exec+0x2df>
8010129c:	89 d1                	mov    %edx,%ecx
8010129e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
801012a0:	83 c1 01             	add    $0x1,%ecx
801012a3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
801012a5:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
801012a8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
801012ab:	84 c0                	test   %al,%al
801012ad:	75 f1                	jne    801012a0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801012af:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
801012b5:	83 ec 04             	sub    $0x4,%esp
801012b8:	6a 10                	push   $0x10
801012ba:	89 f8                	mov    %edi,%eax
801012bc:	52                   	push   %edx
801012bd:	83 c0 6c             	add    $0x6c,%eax
801012c0:	50                   	push   %eax
801012c1:	e8 aa 3d 00 00       	call   80105070 <safestrcpy>
  curproc->pgdir = pgdir;
801012c6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
801012cc:	89 f8                	mov    %edi,%eax
801012ce:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
801012d1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
801012d3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
801012d6:	89 c1                	mov    %eax,%ecx
801012d8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
801012de:	8b 40 18             	mov    0x18(%eax),%eax
801012e1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
801012e4:	8b 41 18             	mov    0x18(%ecx),%eax
801012e7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
801012ea:	89 0c 24             	mov    %ecx,(%esp)
801012ed:	e8 3e 61 00 00       	call   80107430 <switchuvm>
  freevm(oldpgdir);
801012f2:	89 3c 24             	mov    %edi,(%esp)
801012f5:	e8 f6 64 00 00       	call   801077f0 <freevm>
  return 0;
801012fa:	83 c4 10             	add    $0x10,%esp
801012fd:	31 c0                	xor    %eax,%eax
801012ff:	e9 3c fd ff ff       	jmp    80101040 <exec+0x70>
    end_op();
80101304:	e8 e7 1f 00 00       	call   801032f0 <end_op>
    cprintf("exec: fail\n");
80101309:	83 ec 0c             	sub    $0xc,%esp
8010130c:	68 81 7b 10 80       	push   $0x80107b81
80101311:	e8 9a f3 ff ff       	call   801006b0 <cprintf>
    return -1;
80101316:	83 c4 10             	add    $0x10,%esp
80101319:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010131e:	e9 1d fd ff ff       	jmp    80101040 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101323:	31 ff                	xor    %edi,%edi
80101325:	be 00 20 00 00       	mov    $0x2000,%esi
8010132a:	e9 39 fe ff ff       	jmp    80101168 <exec+0x198>
8010132f:	90                   	nop

80101330 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101330:	f3 0f 1e fb          	endbr32 
80101334:	55                   	push   %ebp
80101335:	89 e5                	mov    %esp,%ebp
80101337:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
8010133a:	68 8d 7b 10 80       	push   $0x80107b8d
8010133f:	68 40 15 11 80       	push   $0x80111540
80101344:	e8 d7 38 00 00       	call   80104c20 <initlock>
}
80101349:	83 c4 10             	add    $0x10,%esp
8010134c:	c9                   	leave  
8010134d:	c3                   	ret    
8010134e:	66 90                	xchg   %ax,%ax

80101350 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101350:	f3 0f 1e fb          	endbr32 
80101354:	55                   	push   %ebp
80101355:	89 e5                	mov    %esp,%ebp
80101357:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101358:	bb 74 15 11 80       	mov    $0x80111574,%ebx
{
8010135d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80101360:	68 40 15 11 80       	push   $0x80111540
80101365:	e8 36 3a 00 00       	call   80104da0 <acquire>
8010136a:	83 c4 10             	add    $0x10,%esp
8010136d:	eb 0c                	jmp    8010137b <filealloc+0x2b>
8010136f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101370:	83 c3 18             	add    $0x18,%ebx
80101373:	81 fb d4 1e 11 80    	cmp    $0x80111ed4,%ebx
80101379:	74 25                	je     801013a0 <filealloc+0x50>
    if(f->ref == 0){
8010137b:	8b 43 04             	mov    0x4(%ebx),%eax
8010137e:	85 c0                	test   %eax,%eax
80101380:	75 ee                	jne    80101370 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101382:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101385:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010138c:	68 40 15 11 80       	push   $0x80111540
80101391:	e8 ca 3a 00 00       	call   80104e60 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101396:	89 d8                	mov    %ebx,%eax
      return f;
80101398:	83 c4 10             	add    $0x10,%esp
}
8010139b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010139e:	c9                   	leave  
8010139f:	c3                   	ret    
  release(&ftable.lock);
801013a0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801013a3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801013a5:	68 40 15 11 80       	push   $0x80111540
801013aa:	e8 b1 3a 00 00       	call   80104e60 <release>
}
801013af:	89 d8                	mov    %ebx,%eax
  return 0;
801013b1:	83 c4 10             	add    $0x10,%esp
}
801013b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013b7:	c9                   	leave  
801013b8:	c3                   	ret    
801013b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801013c0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801013c0:	f3 0f 1e fb          	endbr32 
801013c4:	55                   	push   %ebp
801013c5:	89 e5                	mov    %esp,%ebp
801013c7:	53                   	push   %ebx
801013c8:	83 ec 10             	sub    $0x10,%esp
801013cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801013ce:	68 40 15 11 80       	push   $0x80111540
801013d3:	e8 c8 39 00 00       	call   80104da0 <acquire>
  if(f->ref < 1)
801013d8:	8b 43 04             	mov    0x4(%ebx),%eax
801013db:	83 c4 10             	add    $0x10,%esp
801013de:	85 c0                	test   %eax,%eax
801013e0:	7e 1a                	jle    801013fc <filedup+0x3c>
    panic("filedup");
  f->ref++;
801013e2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801013e5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801013e8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801013eb:	68 40 15 11 80       	push   $0x80111540
801013f0:	e8 6b 3a 00 00       	call   80104e60 <release>
  return f;
}
801013f5:	89 d8                	mov    %ebx,%eax
801013f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013fa:	c9                   	leave  
801013fb:	c3                   	ret    
    panic("filedup");
801013fc:	83 ec 0c             	sub    $0xc,%esp
801013ff:	68 94 7b 10 80       	push   $0x80107b94
80101404:	e8 87 ef ff ff       	call   80100390 <panic>
80101409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101410 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101410:	f3 0f 1e fb          	endbr32 
80101414:	55                   	push   %ebp
80101415:	89 e5                	mov    %esp,%ebp
80101417:	57                   	push   %edi
80101418:	56                   	push   %esi
80101419:	53                   	push   %ebx
8010141a:	83 ec 28             	sub    $0x28,%esp
8010141d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80101420:	68 40 15 11 80       	push   $0x80111540
80101425:	e8 76 39 00 00       	call   80104da0 <acquire>
  if(f->ref < 1)
8010142a:	8b 53 04             	mov    0x4(%ebx),%edx
8010142d:	83 c4 10             	add    $0x10,%esp
80101430:	85 d2                	test   %edx,%edx
80101432:	0f 8e a1 00 00 00    	jle    801014d9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101438:	83 ea 01             	sub    $0x1,%edx
8010143b:	89 53 04             	mov    %edx,0x4(%ebx)
8010143e:	75 40                	jne    80101480 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101440:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101444:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101447:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101449:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010144f:	8b 73 0c             	mov    0xc(%ebx),%esi
80101452:	88 45 e7             	mov    %al,-0x19(%ebp)
80101455:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101458:	68 40 15 11 80       	push   $0x80111540
  ff = *f;
8010145d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101460:	e8 fb 39 00 00       	call   80104e60 <release>

  if(ff.type == FD_PIPE)
80101465:	83 c4 10             	add    $0x10,%esp
80101468:	83 ff 01             	cmp    $0x1,%edi
8010146b:	74 53                	je     801014c0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
8010146d:	83 ff 02             	cmp    $0x2,%edi
80101470:	74 26                	je     80101498 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101472:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101475:	5b                   	pop    %ebx
80101476:	5e                   	pop    %esi
80101477:	5f                   	pop    %edi
80101478:	5d                   	pop    %ebp
80101479:	c3                   	ret    
8010147a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101480:	c7 45 08 40 15 11 80 	movl   $0x80111540,0x8(%ebp)
}
80101487:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010148a:	5b                   	pop    %ebx
8010148b:	5e                   	pop    %esi
8010148c:	5f                   	pop    %edi
8010148d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010148e:	e9 cd 39 00 00       	jmp    80104e60 <release>
80101493:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101497:	90                   	nop
    begin_op();
80101498:	e8 e3 1d 00 00       	call   80103280 <begin_op>
    iput(ff.ip);
8010149d:	83 ec 0c             	sub    $0xc,%esp
801014a0:	ff 75 e0             	pushl  -0x20(%ebp)
801014a3:	e8 38 09 00 00       	call   80101de0 <iput>
    end_op();
801014a8:	83 c4 10             	add    $0x10,%esp
}
801014ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014ae:	5b                   	pop    %ebx
801014af:	5e                   	pop    %esi
801014b0:	5f                   	pop    %edi
801014b1:	5d                   	pop    %ebp
    end_op();
801014b2:	e9 39 1e 00 00       	jmp    801032f0 <end_op>
801014b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014be:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801014c0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801014c4:	83 ec 08             	sub    $0x8,%esp
801014c7:	53                   	push   %ebx
801014c8:	56                   	push   %esi
801014c9:	e8 82 25 00 00       	call   80103a50 <pipeclose>
801014ce:	83 c4 10             	add    $0x10,%esp
}
801014d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014d4:	5b                   	pop    %ebx
801014d5:	5e                   	pop    %esi
801014d6:	5f                   	pop    %edi
801014d7:	5d                   	pop    %ebp
801014d8:	c3                   	ret    
    panic("fileclose");
801014d9:	83 ec 0c             	sub    $0xc,%esp
801014dc:	68 9c 7b 10 80       	push   $0x80107b9c
801014e1:	e8 aa ee ff ff       	call   80100390 <panic>
801014e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ed:	8d 76 00             	lea    0x0(%esi),%esi

801014f0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801014f0:	f3 0f 1e fb          	endbr32 
801014f4:	55                   	push   %ebp
801014f5:	89 e5                	mov    %esp,%ebp
801014f7:	53                   	push   %ebx
801014f8:	83 ec 04             	sub    $0x4,%esp
801014fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801014fe:	83 3b 02             	cmpl   $0x2,(%ebx)
80101501:	75 2d                	jne    80101530 <filestat+0x40>
    ilock(f->ip);
80101503:	83 ec 0c             	sub    $0xc,%esp
80101506:	ff 73 10             	pushl  0x10(%ebx)
80101509:	e8 a2 07 00 00       	call   80101cb0 <ilock>
    stati(f->ip, st);
8010150e:	58                   	pop    %eax
8010150f:	5a                   	pop    %edx
80101510:	ff 75 0c             	pushl  0xc(%ebp)
80101513:	ff 73 10             	pushl  0x10(%ebx)
80101516:	e8 65 0a 00 00       	call   80101f80 <stati>
    iunlock(f->ip);
8010151b:	59                   	pop    %ecx
8010151c:	ff 73 10             	pushl  0x10(%ebx)
8010151f:	e8 6c 08 00 00       	call   80101d90 <iunlock>
    return 0;
  }
  return -1;
}
80101524:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101527:	83 c4 10             	add    $0x10,%esp
8010152a:	31 c0                	xor    %eax,%eax
}
8010152c:	c9                   	leave  
8010152d:	c3                   	ret    
8010152e:	66 90                	xchg   %ax,%ax
80101530:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101533:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101538:	c9                   	leave  
80101539:	c3                   	ret    
8010153a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101540 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	57                   	push   %edi
80101548:	56                   	push   %esi
80101549:	53                   	push   %ebx
8010154a:	83 ec 0c             	sub    $0xc,%esp
8010154d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101550:	8b 75 0c             	mov    0xc(%ebp),%esi
80101553:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101556:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010155a:	74 64                	je     801015c0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010155c:	8b 03                	mov    (%ebx),%eax
8010155e:	83 f8 01             	cmp    $0x1,%eax
80101561:	74 45                	je     801015a8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101563:	83 f8 02             	cmp    $0x2,%eax
80101566:	75 5f                	jne    801015c7 <fileread+0x87>
    ilock(f->ip);
80101568:	83 ec 0c             	sub    $0xc,%esp
8010156b:	ff 73 10             	pushl  0x10(%ebx)
8010156e:	e8 3d 07 00 00       	call   80101cb0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101573:	57                   	push   %edi
80101574:	ff 73 14             	pushl  0x14(%ebx)
80101577:	56                   	push   %esi
80101578:	ff 73 10             	pushl  0x10(%ebx)
8010157b:	e8 30 0a 00 00       	call   80101fb0 <readi>
80101580:	83 c4 20             	add    $0x20,%esp
80101583:	89 c6                	mov    %eax,%esi
80101585:	85 c0                	test   %eax,%eax
80101587:	7e 03                	jle    8010158c <fileread+0x4c>
      f->off += r;
80101589:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010158c:	83 ec 0c             	sub    $0xc,%esp
8010158f:	ff 73 10             	pushl  0x10(%ebx)
80101592:	e8 f9 07 00 00       	call   80101d90 <iunlock>
    return r;
80101597:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010159a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010159d:	89 f0                	mov    %esi,%eax
8010159f:	5b                   	pop    %ebx
801015a0:	5e                   	pop    %esi
801015a1:	5f                   	pop    %edi
801015a2:	5d                   	pop    %ebp
801015a3:	c3                   	ret    
801015a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
801015a8:	8b 43 0c             	mov    0xc(%ebx),%eax
801015ab:	89 45 08             	mov    %eax,0x8(%ebp)
}
801015ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015b1:	5b                   	pop    %ebx
801015b2:	5e                   	pop    %esi
801015b3:	5f                   	pop    %edi
801015b4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801015b5:	e9 36 26 00 00       	jmp    80103bf0 <piperead>
801015ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801015c0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801015c5:	eb d3                	jmp    8010159a <fileread+0x5a>
  panic("fileread");
801015c7:	83 ec 0c             	sub    $0xc,%esp
801015ca:	68 a6 7b 10 80       	push   $0x80107ba6
801015cf:	e8 bc ed ff ff       	call   80100390 <panic>
801015d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015df:	90                   	nop

801015e0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801015e0:	f3 0f 1e fb          	endbr32 
801015e4:	55                   	push   %ebp
801015e5:	89 e5                	mov    %esp,%ebp
801015e7:	57                   	push   %edi
801015e8:	56                   	push   %esi
801015e9:	53                   	push   %ebx
801015ea:	83 ec 1c             	sub    $0x1c,%esp
801015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801015f0:	8b 75 08             	mov    0x8(%ebp),%esi
801015f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801015f6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801015f9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801015fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101600:	0f 84 c1 00 00 00    	je     801016c7 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101606:	8b 06                	mov    (%esi),%eax
80101608:	83 f8 01             	cmp    $0x1,%eax
8010160b:	0f 84 c3 00 00 00    	je     801016d4 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101611:	83 f8 02             	cmp    $0x2,%eax
80101614:	0f 85 cc 00 00 00    	jne    801016e6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010161a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010161d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010161f:	85 c0                	test   %eax,%eax
80101621:	7f 34                	jg     80101657 <filewrite+0x77>
80101623:	e9 98 00 00 00       	jmp    801016c0 <filewrite+0xe0>
80101628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010162f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101630:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101633:	83 ec 0c             	sub    $0xc,%esp
80101636:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101639:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010163c:	e8 4f 07 00 00       	call   80101d90 <iunlock>
      end_op();
80101641:	e8 aa 1c 00 00       	call   801032f0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101646:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101649:	83 c4 10             	add    $0x10,%esp
8010164c:	39 c3                	cmp    %eax,%ebx
8010164e:	75 60                	jne    801016b0 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101650:	01 df                	add    %ebx,%edi
    while(i < n){
80101652:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101655:	7e 69                	jle    801016c0 <filewrite+0xe0>
      int n1 = n - i;
80101657:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010165a:	b8 00 06 00 00       	mov    $0x600,%eax
8010165f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101661:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101667:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010166a:	e8 11 1c 00 00       	call   80103280 <begin_op>
      ilock(f->ip);
8010166f:	83 ec 0c             	sub    $0xc,%esp
80101672:	ff 76 10             	pushl  0x10(%esi)
80101675:	e8 36 06 00 00       	call   80101cb0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010167a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010167d:	53                   	push   %ebx
8010167e:	ff 76 14             	pushl  0x14(%esi)
80101681:	01 f8                	add    %edi,%eax
80101683:	50                   	push   %eax
80101684:	ff 76 10             	pushl  0x10(%esi)
80101687:	e8 24 0a 00 00       	call   801020b0 <writei>
8010168c:	83 c4 20             	add    $0x20,%esp
8010168f:	85 c0                	test   %eax,%eax
80101691:	7f 9d                	jg     80101630 <filewrite+0x50>
      iunlock(f->ip);
80101693:	83 ec 0c             	sub    $0xc,%esp
80101696:	ff 76 10             	pushl  0x10(%esi)
80101699:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010169c:	e8 ef 06 00 00       	call   80101d90 <iunlock>
      end_op();
801016a1:	e8 4a 1c 00 00       	call   801032f0 <end_op>
      if(r < 0)
801016a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016a9:	83 c4 10             	add    $0x10,%esp
801016ac:	85 c0                	test   %eax,%eax
801016ae:	75 17                	jne    801016c7 <filewrite+0xe7>
        panic("short filewrite");
801016b0:	83 ec 0c             	sub    $0xc,%esp
801016b3:	68 af 7b 10 80       	push   $0x80107baf
801016b8:	e8 d3 ec ff ff       	call   80100390 <panic>
801016bd:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
801016c0:	89 f8                	mov    %edi,%eax
801016c2:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801016c5:	74 05                	je     801016cc <filewrite+0xec>
801016c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801016cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016cf:	5b                   	pop    %ebx
801016d0:	5e                   	pop    %esi
801016d1:	5f                   	pop    %edi
801016d2:	5d                   	pop    %ebp
801016d3:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801016d4:	8b 46 0c             	mov    0xc(%esi),%eax
801016d7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801016da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016dd:	5b                   	pop    %ebx
801016de:	5e                   	pop    %esi
801016df:	5f                   	pop    %edi
801016e0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801016e1:	e9 0a 24 00 00       	jmp    80103af0 <pipewrite>
  panic("filewrite");
801016e6:	83 ec 0c             	sub    $0xc,%esp
801016e9:	68 b5 7b 10 80       	push   $0x80107bb5
801016ee:	e8 9d ec ff ff       	call   80100390 <panic>
801016f3:	66 90                	xchg   %ax,%ax
801016f5:	66 90                	xchg   %ax,%ax
801016f7:	66 90                	xchg   %ax,%ax
801016f9:	66 90                	xchg   %ax,%ax
801016fb:	66 90                	xchg   %ax,%ax
801016fd:	66 90                	xchg   %ax,%ax
801016ff:	90                   	nop

80101700 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101700:	55                   	push   %ebp
80101701:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101703:	89 d0                	mov    %edx,%eax
80101705:	c1 e8 0c             	shr    $0xc,%eax
80101708:	03 05 58 1f 11 80    	add    0x80111f58,%eax
{
8010170e:	89 e5                	mov    %esp,%ebp
80101710:	56                   	push   %esi
80101711:	53                   	push   %ebx
80101712:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101714:	83 ec 08             	sub    $0x8,%esp
80101717:	50                   	push   %eax
80101718:	51                   	push   %ecx
80101719:	e8 b2 e9 ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010171e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101720:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101723:	ba 01 00 00 00       	mov    $0x1,%edx
80101728:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010172b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101731:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101734:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101736:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
8010173b:	85 d1                	test   %edx,%ecx
8010173d:	74 25                	je     80101764 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010173f:	f7 d2                	not    %edx
  log_write(bp);
80101741:	83 ec 0c             	sub    $0xc,%esp
80101744:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101746:	21 ca                	and    %ecx,%edx
80101748:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010174c:	50                   	push   %eax
8010174d:	e8 0e 1d 00 00       	call   80103460 <log_write>
  brelse(bp);
80101752:	89 34 24             	mov    %esi,(%esp)
80101755:	e8 96 ea ff ff       	call   801001f0 <brelse>
}
8010175a:	83 c4 10             	add    $0x10,%esp
8010175d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101760:	5b                   	pop    %ebx
80101761:	5e                   	pop    %esi
80101762:	5d                   	pop    %ebp
80101763:	c3                   	ret    
    panic("freeing free block");
80101764:	83 ec 0c             	sub    $0xc,%esp
80101767:	68 bf 7b 10 80       	push   $0x80107bbf
8010176c:	e8 1f ec ff ff       	call   80100390 <panic>
80101771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <balloc>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	57                   	push   %edi
80101784:	56                   	push   %esi
80101785:	53                   	push   %ebx
80101786:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101789:	8b 0d 40 1f 11 80    	mov    0x80111f40,%ecx
{
8010178f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101792:	85 c9                	test   %ecx,%ecx
80101794:	0f 84 87 00 00 00    	je     80101821 <balloc+0xa1>
8010179a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801017a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801017a4:	83 ec 08             	sub    $0x8,%esp
801017a7:	89 f0                	mov    %esi,%eax
801017a9:	c1 f8 0c             	sar    $0xc,%eax
801017ac:	03 05 58 1f 11 80    	add    0x80111f58,%eax
801017b2:	50                   	push   %eax
801017b3:	ff 75 d8             	pushl  -0x28(%ebp)
801017b6:	e8 15 e9 ff ff       	call   801000d0 <bread>
801017bb:	83 c4 10             	add    $0x10,%esp
801017be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801017c1:	a1 40 1f 11 80       	mov    0x80111f40,%eax
801017c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801017c9:	31 c0                	xor    %eax,%eax
801017cb:	eb 2f                	jmp    801017fc <balloc+0x7c>
801017cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801017d0:	89 c1                	mov    %eax,%ecx
801017d2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801017d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801017da:	83 e1 07             	and    $0x7,%ecx
801017dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801017df:	89 c1                	mov    %eax,%ecx
801017e1:	c1 f9 03             	sar    $0x3,%ecx
801017e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801017e9:	89 fa                	mov    %edi,%edx
801017eb:	85 df                	test   %ebx,%edi
801017ed:	74 41                	je     80101830 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801017ef:	83 c0 01             	add    $0x1,%eax
801017f2:	83 c6 01             	add    $0x1,%esi
801017f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801017fa:	74 05                	je     80101801 <balloc+0x81>
801017fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801017ff:	77 cf                	ja     801017d0 <balloc+0x50>
    brelse(bp);
80101801:	83 ec 0c             	sub    $0xc,%esp
80101804:	ff 75 e4             	pushl  -0x1c(%ebp)
80101807:	e8 e4 e9 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010180c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101813:	83 c4 10             	add    $0x10,%esp
80101816:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101819:	39 05 40 1f 11 80    	cmp    %eax,0x80111f40
8010181f:	77 80                	ja     801017a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101821:	83 ec 0c             	sub    $0xc,%esp
80101824:	68 d2 7b 10 80       	push   $0x80107bd2
80101829:	e8 62 eb ff ff       	call   80100390 <panic>
8010182e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101830:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101833:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101836:	09 da                	or     %ebx,%edx
80101838:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010183c:	57                   	push   %edi
8010183d:	e8 1e 1c 00 00       	call   80103460 <log_write>
        brelse(bp);
80101842:	89 3c 24             	mov    %edi,(%esp)
80101845:	e8 a6 e9 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010184a:	58                   	pop    %eax
8010184b:	5a                   	pop    %edx
8010184c:	56                   	push   %esi
8010184d:	ff 75 d8             	pushl  -0x28(%ebp)
80101850:	e8 7b e8 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101855:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101858:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010185a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010185d:	68 00 02 00 00       	push   $0x200
80101862:	6a 00                	push   $0x0
80101864:	50                   	push   %eax
80101865:	e8 46 36 00 00       	call   80104eb0 <memset>
  log_write(bp);
8010186a:	89 1c 24             	mov    %ebx,(%esp)
8010186d:	e8 ee 1b 00 00       	call   80103460 <log_write>
  brelse(bp);
80101872:	89 1c 24             	mov    %ebx,(%esp)
80101875:	e8 76 e9 ff ff       	call   801001f0 <brelse>
}
8010187a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010187d:	89 f0                	mov    %esi,%eax
8010187f:	5b                   	pop    %ebx
80101880:	5e                   	pop    %esi
80101881:	5f                   	pop    %edi
80101882:	5d                   	pop    %ebp
80101883:	c3                   	ret    
80101884:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010188f:	90                   	nop

80101890 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	57                   	push   %edi
80101894:	89 c7                	mov    %eax,%edi
80101896:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101897:	31 f6                	xor    %esi,%esi
{
80101899:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010189a:	bb 94 1f 11 80       	mov    $0x80111f94,%ebx
{
8010189f:	83 ec 28             	sub    $0x28,%esp
801018a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801018a5:	68 60 1f 11 80       	push   $0x80111f60
801018aa:	e8 f1 34 00 00       	call   80104da0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801018b2:	83 c4 10             	add    $0x10,%esp
801018b5:	eb 1b                	jmp    801018d2 <iget+0x42>
801018b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018be:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018c0:	39 3b                	cmp    %edi,(%ebx)
801018c2:	74 6c                	je     80101930 <iget+0xa0>
801018c4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018ca:	81 fb b4 3b 11 80    	cmp    $0x80113bb4,%ebx
801018d0:	73 26                	jae    801018f8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018d2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801018d5:	85 c9                	test   %ecx,%ecx
801018d7:	7f e7                	jg     801018c0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801018d9:	85 f6                	test   %esi,%esi
801018db:	75 e7                	jne    801018c4 <iget+0x34>
801018dd:	89 d8                	mov    %ebx,%eax
801018df:	81 c3 90 00 00 00    	add    $0x90,%ebx
801018e5:	85 c9                	test   %ecx,%ecx
801018e7:	75 6e                	jne    80101957 <iget+0xc7>
801018e9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018eb:	81 fb b4 3b 11 80    	cmp    $0x80113bb4,%ebx
801018f1:	72 df                	jb     801018d2 <iget+0x42>
801018f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018f7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801018f8:	85 f6                	test   %esi,%esi
801018fa:	74 73                	je     8010196f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801018fc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801018ff:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101901:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101904:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010190b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101912:	68 60 1f 11 80       	push   $0x80111f60
80101917:	e8 44 35 00 00       	call   80104e60 <release>

  return ip;
8010191c:	83 c4 10             	add    $0x10,%esp
}
8010191f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101922:	89 f0                	mov    %esi,%eax
80101924:	5b                   	pop    %ebx
80101925:	5e                   	pop    %esi
80101926:	5f                   	pop    %edi
80101927:	5d                   	pop    %ebp
80101928:	c3                   	ret    
80101929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101930:	39 53 04             	cmp    %edx,0x4(%ebx)
80101933:	75 8f                	jne    801018c4 <iget+0x34>
      release(&icache.lock);
80101935:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101938:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010193b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010193d:	68 60 1f 11 80       	push   $0x80111f60
      ip->ref++;
80101942:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101945:	e8 16 35 00 00       	call   80104e60 <release>
      return ip;
8010194a:	83 c4 10             	add    $0x10,%esp
}
8010194d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101950:	89 f0                	mov    %esi,%eax
80101952:	5b                   	pop    %ebx
80101953:	5e                   	pop    %esi
80101954:	5f                   	pop    %edi
80101955:	5d                   	pop    %ebp
80101956:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101957:	81 fb b4 3b 11 80    	cmp    $0x80113bb4,%ebx
8010195d:	73 10                	jae    8010196f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010195f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101962:	85 c9                	test   %ecx,%ecx
80101964:	0f 8f 56 ff ff ff    	jg     801018c0 <iget+0x30>
8010196a:	e9 6e ff ff ff       	jmp    801018dd <iget+0x4d>
    panic("iget: no inodes");
8010196f:	83 ec 0c             	sub    $0xc,%esp
80101972:	68 e8 7b 10 80       	push   $0x80107be8
80101977:	e8 14 ea ff ff       	call   80100390 <panic>
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101980 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	57                   	push   %edi
80101984:	56                   	push   %esi
80101985:	89 c6                	mov    %eax,%esi
80101987:	53                   	push   %ebx
80101988:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010198b:	83 fa 0b             	cmp    $0xb,%edx
8010198e:	0f 86 84 00 00 00    	jbe    80101a18 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101994:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101997:	83 fb 7f             	cmp    $0x7f,%ebx
8010199a:	0f 87 98 00 00 00    	ja     80101a38 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801019a0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801019a6:	8b 16                	mov    (%esi),%edx
801019a8:	85 c0                	test   %eax,%eax
801019aa:	74 54                	je     80101a00 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801019ac:	83 ec 08             	sub    $0x8,%esp
801019af:	50                   	push   %eax
801019b0:	52                   	push   %edx
801019b1:	e8 1a e7 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801019b6:	83 c4 10             	add    $0x10,%esp
801019b9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801019bd:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801019bf:	8b 1a                	mov    (%edx),%ebx
801019c1:	85 db                	test   %ebx,%ebx
801019c3:	74 1b                	je     801019e0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801019c5:	83 ec 0c             	sub    $0xc,%esp
801019c8:	57                   	push   %edi
801019c9:	e8 22 e8 ff ff       	call   801001f0 <brelse>
    return addr;
801019ce:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801019d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019d4:	89 d8                	mov    %ebx,%eax
801019d6:	5b                   	pop    %ebx
801019d7:	5e                   	pop    %esi
801019d8:	5f                   	pop    %edi
801019d9:	5d                   	pop    %ebp
801019da:	c3                   	ret    
801019db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019df:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801019e0:	8b 06                	mov    (%esi),%eax
801019e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801019e5:	e8 96 fd ff ff       	call   80101780 <balloc>
801019ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801019ed:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801019f0:	89 c3                	mov    %eax,%ebx
801019f2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801019f4:	57                   	push   %edi
801019f5:	e8 66 1a 00 00       	call   80103460 <log_write>
801019fa:	83 c4 10             	add    $0x10,%esp
801019fd:	eb c6                	jmp    801019c5 <bmap+0x45>
801019ff:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101a00:	89 d0                	mov    %edx,%eax
80101a02:	e8 79 fd ff ff       	call   80101780 <balloc>
80101a07:	8b 16                	mov    (%esi),%edx
80101a09:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101a0f:	eb 9b                	jmp    801019ac <bmap+0x2c>
80101a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101a18:	8d 3c 90             	lea    (%eax,%edx,4),%edi
80101a1b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101a1e:	85 db                	test   %ebx,%ebx
80101a20:	75 af                	jne    801019d1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101a22:	8b 00                	mov    (%eax),%eax
80101a24:	e8 57 fd ff ff       	call   80101780 <balloc>
80101a29:	89 47 5c             	mov    %eax,0x5c(%edi)
80101a2c:	89 c3                	mov    %eax,%ebx
}
80101a2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a31:	89 d8                	mov    %ebx,%eax
80101a33:	5b                   	pop    %ebx
80101a34:	5e                   	pop    %esi
80101a35:	5f                   	pop    %edi
80101a36:	5d                   	pop    %ebp
80101a37:	c3                   	ret    
  panic("bmap: out of range");
80101a38:	83 ec 0c             	sub    $0xc,%esp
80101a3b:	68 f8 7b 10 80       	push   $0x80107bf8
80101a40:	e8 4b e9 ff ff       	call   80100390 <panic>
80101a45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a50 <readsb>:
{
80101a50:	f3 0f 1e fb          	endbr32 
80101a54:	55                   	push   %ebp
80101a55:	89 e5                	mov    %esp,%ebp
80101a57:	56                   	push   %esi
80101a58:	53                   	push   %ebx
80101a59:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101a5c:	83 ec 08             	sub    $0x8,%esp
80101a5f:	6a 01                	push   $0x1
80101a61:	ff 75 08             	pushl  0x8(%ebp)
80101a64:	e8 67 e6 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101a69:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101a6c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101a6e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101a71:	6a 1c                	push   $0x1c
80101a73:	50                   	push   %eax
80101a74:	56                   	push   %esi
80101a75:	e8 d6 34 00 00       	call   80104f50 <memmove>
  brelse(bp);
80101a7a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a7d:	83 c4 10             	add    $0x10,%esp
}
80101a80:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a83:	5b                   	pop    %ebx
80101a84:	5e                   	pop    %esi
80101a85:	5d                   	pop    %ebp
  brelse(bp);
80101a86:	e9 65 e7 ff ff       	jmp    801001f0 <brelse>
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <iinit>:
{
80101a90:	f3 0f 1e fb          	endbr32 
80101a94:	55                   	push   %ebp
80101a95:	89 e5                	mov    %esp,%ebp
80101a97:	53                   	push   %ebx
80101a98:	bb a0 1f 11 80       	mov    $0x80111fa0,%ebx
80101a9d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101aa0:	68 0b 7c 10 80       	push   $0x80107c0b
80101aa5:	68 60 1f 11 80       	push   $0x80111f60
80101aaa:	e8 71 31 00 00       	call   80104c20 <initlock>
  for(i = 0; i < NINODE; i++) {
80101aaf:	83 c4 10             	add    $0x10,%esp
80101ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101ab8:	83 ec 08             	sub    $0x8,%esp
80101abb:	68 12 7c 10 80       	push   $0x80107c12
80101ac0:	53                   	push   %ebx
80101ac1:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101ac7:	e8 14 30 00 00       	call   80104ae0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101acc:	83 c4 10             	add    $0x10,%esp
80101acf:	81 fb c0 3b 11 80    	cmp    $0x80113bc0,%ebx
80101ad5:	75 e1                	jne    80101ab8 <iinit+0x28>
  readsb(dev, &sb);
80101ad7:	83 ec 08             	sub    $0x8,%esp
80101ada:	68 40 1f 11 80       	push   $0x80111f40
80101adf:	ff 75 08             	pushl  0x8(%ebp)
80101ae2:	e8 69 ff ff ff       	call   80101a50 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101ae7:	ff 35 58 1f 11 80    	pushl  0x80111f58
80101aed:	ff 35 54 1f 11 80    	pushl  0x80111f54
80101af3:	ff 35 50 1f 11 80    	pushl  0x80111f50
80101af9:	ff 35 4c 1f 11 80    	pushl  0x80111f4c
80101aff:	ff 35 48 1f 11 80    	pushl  0x80111f48
80101b05:	ff 35 44 1f 11 80    	pushl  0x80111f44
80101b0b:	ff 35 40 1f 11 80    	pushl  0x80111f40
80101b11:	68 78 7c 10 80       	push   $0x80107c78
80101b16:	e8 95 eb ff ff       	call   801006b0 <cprintf>
}
80101b1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101b1e:	83 c4 30             	add    $0x30,%esp
80101b21:	c9                   	leave  
80101b22:	c3                   	ret    
80101b23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101b30 <ialloc>:
{
80101b30:	f3 0f 1e fb          	endbr32 
80101b34:	55                   	push   %ebp
80101b35:	89 e5                	mov    %esp,%ebp
80101b37:	57                   	push   %edi
80101b38:	56                   	push   %esi
80101b39:	53                   	push   %ebx
80101b3a:	83 ec 1c             	sub    $0x1c,%esp
80101b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101b40:	83 3d 48 1f 11 80 01 	cmpl   $0x1,0x80111f48
{
80101b47:	8b 75 08             	mov    0x8(%ebp),%esi
80101b4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101b4d:	0f 86 8d 00 00 00    	jbe    80101be0 <ialloc+0xb0>
80101b53:	bf 01 00 00 00       	mov    $0x1,%edi
80101b58:	eb 1d                	jmp    80101b77 <ialloc+0x47>
80101b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101b60:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101b63:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101b66:	53                   	push   %ebx
80101b67:	e8 84 e6 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101b6c:	83 c4 10             	add    $0x10,%esp
80101b6f:	3b 3d 48 1f 11 80    	cmp    0x80111f48,%edi
80101b75:	73 69                	jae    80101be0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101b77:	89 f8                	mov    %edi,%eax
80101b79:	83 ec 08             	sub    $0x8,%esp
80101b7c:	c1 e8 03             	shr    $0x3,%eax
80101b7f:	03 05 54 1f 11 80    	add    0x80111f54,%eax
80101b85:	50                   	push   %eax
80101b86:	56                   	push   %esi
80101b87:	e8 44 e5 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101b8c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101b8f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101b91:	89 f8                	mov    %edi,%eax
80101b93:	83 e0 07             	and    $0x7,%eax
80101b96:	c1 e0 06             	shl    $0x6,%eax
80101b99:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101b9d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101ba1:	75 bd                	jne    80101b60 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101ba3:	83 ec 04             	sub    $0x4,%esp
80101ba6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101ba9:	6a 40                	push   $0x40
80101bab:	6a 00                	push   $0x0
80101bad:	51                   	push   %ecx
80101bae:	e8 fd 32 00 00       	call   80104eb0 <memset>
      dip->type = type;
80101bb3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101bb7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101bba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101bbd:	89 1c 24             	mov    %ebx,(%esp)
80101bc0:	e8 9b 18 00 00       	call   80103460 <log_write>
      brelse(bp);
80101bc5:	89 1c 24             	mov    %ebx,(%esp)
80101bc8:	e8 23 e6 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101bcd:	83 c4 10             	add    $0x10,%esp
}
80101bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101bd3:	89 fa                	mov    %edi,%edx
}
80101bd5:	5b                   	pop    %ebx
      return iget(dev, inum);
80101bd6:	89 f0                	mov    %esi,%eax
}
80101bd8:	5e                   	pop    %esi
80101bd9:	5f                   	pop    %edi
80101bda:	5d                   	pop    %ebp
      return iget(dev, inum);
80101bdb:	e9 b0 fc ff ff       	jmp    80101890 <iget>
  panic("ialloc: no inodes");
80101be0:	83 ec 0c             	sub    $0xc,%esp
80101be3:	68 18 7c 10 80       	push   $0x80107c18
80101be8:	e8 a3 e7 ff ff       	call   80100390 <panic>
80101bed:	8d 76 00             	lea    0x0(%esi),%esi

80101bf0 <iupdate>:
{
80101bf0:	f3 0f 1e fb          	endbr32 
80101bf4:	55                   	push   %ebp
80101bf5:	89 e5                	mov    %esp,%ebp
80101bf7:	56                   	push   %esi
80101bf8:	53                   	push   %ebx
80101bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101bfc:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101bff:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c02:	83 ec 08             	sub    $0x8,%esp
80101c05:	c1 e8 03             	shr    $0x3,%eax
80101c08:	03 05 54 1f 11 80    	add    0x80111f54,%eax
80101c0e:	50                   	push   %eax
80101c0f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101c12:	e8 b9 e4 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101c17:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c1b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c1e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101c20:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101c23:	83 e0 07             	and    $0x7,%eax
80101c26:	c1 e0 06             	shl    $0x6,%eax
80101c29:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101c2d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101c30:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c34:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101c37:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101c3b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101c3f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101c43:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101c47:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101c4b:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101c4e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c51:	6a 34                	push   $0x34
80101c53:	53                   	push   %ebx
80101c54:	50                   	push   %eax
80101c55:	e8 f6 32 00 00       	call   80104f50 <memmove>
  log_write(bp);
80101c5a:	89 34 24             	mov    %esi,(%esp)
80101c5d:	e8 fe 17 00 00       	call   80103460 <log_write>
  brelse(bp);
80101c62:	89 75 08             	mov    %esi,0x8(%ebp)
80101c65:	83 c4 10             	add    $0x10,%esp
}
80101c68:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c6b:	5b                   	pop    %ebx
80101c6c:	5e                   	pop    %esi
80101c6d:	5d                   	pop    %ebp
  brelse(bp);
80101c6e:	e9 7d e5 ff ff       	jmp    801001f0 <brelse>
80101c73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c80 <idup>:
{
80101c80:	f3 0f 1e fb          	endbr32 
80101c84:	55                   	push   %ebp
80101c85:	89 e5                	mov    %esp,%ebp
80101c87:	53                   	push   %ebx
80101c88:	83 ec 10             	sub    $0x10,%esp
80101c8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101c8e:	68 60 1f 11 80       	push   $0x80111f60
80101c93:	e8 08 31 00 00       	call   80104da0 <acquire>
  ip->ref++;
80101c98:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c9c:	c7 04 24 60 1f 11 80 	movl   $0x80111f60,(%esp)
80101ca3:	e8 b8 31 00 00       	call   80104e60 <release>
}
80101ca8:	89 d8                	mov    %ebx,%eax
80101caa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101cad:	c9                   	leave  
80101cae:	c3                   	ret    
80101caf:	90                   	nop

80101cb0 <ilock>:
{
80101cb0:	f3 0f 1e fb          	endbr32 
80101cb4:	55                   	push   %ebp
80101cb5:	89 e5                	mov    %esp,%ebp
80101cb7:	56                   	push   %esi
80101cb8:	53                   	push   %ebx
80101cb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101cbc:	85 db                	test   %ebx,%ebx
80101cbe:	0f 84 b3 00 00 00    	je     80101d77 <ilock+0xc7>
80101cc4:	8b 53 08             	mov    0x8(%ebx),%edx
80101cc7:	85 d2                	test   %edx,%edx
80101cc9:	0f 8e a8 00 00 00    	jle    80101d77 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101ccf:	83 ec 0c             	sub    $0xc,%esp
80101cd2:	8d 43 0c             	lea    0xc(%ebx),%eax
80101cd5:	50                   	push   %eax
80101cd6:	e8 45 2e 00 00       	call   80104b20 <acquiresleep>
  if(ip->valid == 0){
80101cdb:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101cde:	83 c4 10             	add    $0x10,%esp
80101ce1:	85 c0                	test   %eax,%eax
80101ce3:	74 0b                	je     80101cf0 <ilock+0x40>
}
80101ce5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ce8:	5b                   	pop    %ebx
80101ce9:	5e                   	pop    %esi
80101cea:	5d                   	pop    %ebp
80101ceb:	c3                   	ret    
80101cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101cf0:	8b 43 04             	mov    0x4(%ebx),%eax
80101cf3:	83 ec 08             	sub    $0x8,%esp
80101cf6:	c1 e8 03             	shr    $0x3,%eax
80101cf9:	03 05 54 1f 11 80    	add    0x80111f54,%eax
80101cff:	50                   	push   %eax
80101d00:	ff 33                	pushl  (%ebx)
80101d02:	e8 c9 e3 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101d07:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d0a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101d0c:	8b 43 04             	mov    0x4(%ebx),%eax
80101d0f:	83 e0 07             	and    $0x7,%eax
80101d12:	c1 e0 06             	shl    $0x6,%eax
80101d15:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101d19:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101d1c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101d1f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101d23:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101d27:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101d2b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101d2f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101d33:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101d37:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101d3b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101d3e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101d41:	6a 34                	push   $0x34
80101d43:	50                   	push   %eax
80101d44:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101d47:	50                   	push   %eax
80101d48:	e8 03 32 00 00       	call   80104f50 <memmove>
    brelse(bp);
80101d4d:	89 34 24             	mov    %esi,(%esp)
80101d50:	e8 9b e4 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101d55:	83 c4 10             	add    $0x10,%esp
80101d58:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101d5d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101d64:	0f 85 7b ff ff ff    	jne    80101ce5 <ilock+0x35>
      panic("ilock: no type");
80101d6a:	83 ec 0c             	sub    $0xc,%esp
80101d6d:	68 30 7c 10 80       	push   $0x80107c30
80101d72:	e8 19 e6 ff ff       	call   80100390 <panic>
    panic("ilock");
80101d77:	83 ec 0c             	sub    $0xc,%esp
80101d7a:	68 2a 7c 10 80       	push   $0x80107c2a
80101d7f:	e8 0c e6 ff ff       	call   80100390 <panic>
80101d84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d8f:	90                   	nop

80101d90 <iunlock>:
{
80101d90:	f3 0f 1e fb          	endbr32 
80101d94:	55                   	push   %ebp
80101d95:	89 e5                	mov    %esp,%ebp
80101d97:	56                   	push   %esi
80101d98:	53                   	push   %ebx
80101d99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101d9c:	85 db                	test   %ebx,%ebx
80101d9e:	74 28                	je     80101dc8 <iunlock+0x38>
80101da0:	83 ec 0c             	sub    $0xc,%esp
80101da3:	8d 73 0c             	lea    0xc(%ebx),%esi
80101da6:	56                   	push   %esi
80101da7:	e8 14 2e 00 00       	call   80104bc0 <holdingsleep>
80101dac:	83 c4 10             	add    $0x10,%esp
80101daf:	85 c0                	test   %eax,%eax
80101db1:	74 15                	je     80101dc8 <iunlock+0x38>
80101db3:	8b 43 08             	mov    0x8(%ebx),%eax
80101db6:	85 c0                	test   %eax,%eax
80101db8:	7e 0e                	jle    80101dc8 <iunlock+0x38>
  releasesleep(&ip->lock);
80101dba:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101dbd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101dc0:	5b                   	pop    %ebx
80101dc1:	5e                   	pop    %esi
80101dc2:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101dc3:	e9 b8 2d 00 00       	jmp    80104b80 <releasesleep>
    panic("iunlock");
80101dc8:	83 ec 0c             	sub    $0xc,%esp
80101dcb:	68 3f 7c 10 80       	push   $0x80107c3f
80101dd0:	e8 bb e5 ff ff       	call   80100390 <panic>
80101dd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101de0 <iput>:
{
80101de0:	f3 0f 1e fb          	endbr32 
80101de4:	55                   	push   %ebp
80101de5:	89 e5                	mov    %esp,%ebp
80101de7:	57                   	push   %edi
80101de8:	56                   	push   %esi
80101de9:	53                   	push   %ebx
80101dea:	83 ec 28             	sub    $0x28,%esp
80101ded:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101df0:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101df3:	57                   	push   %edi
80101df4:	e8 27 2d 00 00       	call   80104b20 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101df9:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101dfc:	83 c4 10             	add    $0x10,%esp
80101dff:	85 d2                	test   %edx,%edx
80101e01:	74 07                	je     80101e0a <iput+0x2a>
80101e03:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101e08:	74 36                	je     80101e40 <iput+0x60>
  releasesleep(&ip->lock);
80101e0a:	83 ec 0c             	sub    $0xc,%esp
80101e0d:	57                   	push   %edi
80101e0e:	e8 6d 2d 00 00       	call   80104b80 <releasesleep>
  acquire(&icache.lock);
80101e13:	c7 04 24 60 1f 11 80 	movl   $0x80111f60,(%esp)
80101e1a:	e8 81 2f 00 00       	call   80104da0 <acquire>
  ip->ref--;
80101e1f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101e23:	83 c4 10             	add    $0x10,%esp
80101e26:	c7 45 08 60 1f 11 80 	movl   $0x80111f60,0x8(%ebp)
}
80101e2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e30:	5b                   	pop    %ebx
80101e31:	5e                   	pop    %esi
80101e32:	5f                   	pop    %edi
80101e33:	5d                   	pop    %ebp
  release(&icache.lock);
80101e34:	e9 27 30 00 00       	jmp    80104e60 <release>
80101e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	68 60 1f 11 80       	push   $0x80111f60
80101e48:	e8 53 2f 00 00       	call   80104da0 <acquire>
    int r = ip->ref;
80101e4d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101e50:	c7 04 24 60 1f 11 80 	movl   $0x80111f60,(%esp)
80101e57:	e8 04 30 00 00       	call   80104e60 <release>
    if(r == 1){
80101e5c:	83 c4 10             	add    $0x10,%esp
80101e5f:	83 fe 01             	cmp    $0x1,%esi
80101e62:	75 a6                	jne    80101e0a <iput+0x2a>
80101e64:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101e6a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101e6d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101e70:	89 cf                	mov    %ecx,%edi
80101e72:	eb 0b                	jmp    80101e7f <iput+0x9f>
80101e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e78:	83 c6 04             	add    $0x4,%esi
80101e7b:	39 fe                	cmp    %edi,%esi
80101e7d:	74 19                	je     80101e98 <iput+0xb8>
    if(ip->addrs[i]){
80101e7f:	8b 16                	mov    (%esi),%edx
80101e81:	85 d2                	test   %edx,%edx
80101e83:	74 f3                	je     80101e78 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101e85:	8b 03                	mov    (%ebx),%eax
80101e87:	e8 74 f8 ff ff       	call   80101700 <bfree>
      ip->addrs[i] = 0;
80101e8c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101e92:	eb e4                	jmp    80101e78 <iput+0x98>
80101e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101e98:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101e9e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101ea1:	85 c0                	test   %eax,%eax
80101ea3:	75 33                	jne    80101ed8 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101ea5:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101ea8:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101eaf:	53                   	push   %ebx
80101eb0:	e8 3b fd ff ff       	call   80101bf0 <iupdate>
      ip->type = 0;
80101eb5:	31 c0                	xor    %eax,%eax
80101eb7:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101ebb:	89 1c 24             	mov    %ebx,(%esp)
80101ebe:	e8 2d fd ff ff       	call   80101bf0 <iupdate>
      ip->valid = 0;
80101ec3:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101eca:	83 c4 10             	add    $0x10,%esp
80101ecd:	e9 38 ff ff ff       	jmp    80101e0a <iput+0x2a>
80101ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101ed8:	83 ec 08             	sub    $0x8,%esp
80101edb:	50                   	push   %eax
80101edc:	ff 33                	pushl  (%ebx)
80101ede:	e8 ed e1 ff ff       	call   801000d0 <bread>
80101ee3:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ee6:	83 c4 10             	add    $0x10,%esp
80101ee9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101eef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101ef2:	8d 70 5c             	lea    0x5c(%eax),%esi
80101ef5:	89 cf                	mov    %ecx,%edi
80101ef7:	eb 0e                	jmp    80101f07 <iput+0x127>
80101ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f00:	83 c6 04             	add    $0x4,%esi
80101f03:	39 f7                	cmp    %esi,%edi
80101f05:	74 19                	je     80101f20 <iput+0x140>
      if(a[j])
80101f07:	8b 16                	mov    (%esi),%edx
80101f09:	85 d2                	test   %edx,%edx
80101f0b:	74 f3                	je     80101f00 <iput+0x120>
        bfree(ip->dev, a[j]);
80101f0d:	8b 03                	mov    (%ebx),%eax
80101f0f:	e8 ec f7 ff ff       	call   80101700 <bfree>
80101f14:	eb ea                	jmp    80101f00 <iput+0x120>
80101f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f1d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101f20:	83 ec 0c             	sub    $0xc,%esp
80101f23:	ff 75 e4             	pushl  -0x1c(%ebp)
80101f26:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101f29:	e8 c2 e2 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101f2e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101f34:	8b 03                	mov    (%ebx),%eax
80101f36:	e8 c5 f7 ff ff       	call   80101700 <bfree>
    ip->addrs[NDIRECT] = 0;
80101f3b:	83 c4 10             	add    $0x10,%esp
80101f3e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101f45:	00 00 00 
80101f48:	e9 58 ff ff ff       	jmp    80101ea5 <iput+0xc5>
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi

80101f50 <iunlockput>:
{
80101f50:	f3 0f 1e fb          	endbr32 
80101f54:	55                   	push   %ebp
80101f55:	89 e5                	mov    %esp,%ebp
80101f57:	53                   	push   %ebx
80101f58:	83 ec 10             	sub    $0x10,%esp
80101f5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101f5e:	53                   	push   %ebx
80101f5f:	e8 2c fe ff ff       	call   80101d90 <iunlock>
  iput(ip);
80101f64:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101f67:	83 c4 10             	add    $0x10,%esp
}
80101f6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f6d:	c9                   	leave  
  iput(ip);
80101f6e:	e9 6d fe ff ff       	jmp    80101de0 <iput>
80101f73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f80 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101f80:	f3 0f 1e fb          	endbr32 
80101f84:	55                   	push   %ebp
80101f85:	89 e5                	mov    %esp,%ebp
80101f87:	8b 55 08             	mov    0x8(%ebp),%edx
80101f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101f8d:	8b 0a                	mov    (%edx),%ecx
80101f8f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101f92:	8b 4a 04             	mov    0x4(%edx),%ecx
80101f95:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101f98:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101f9c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101f9f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101fa3:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101fa7:	8b 52 58             	mov    0x58(%edx),%edx
80101faa:	89 50 10             	mov    %edx,0x10(%eax)
}
80101fad:	5d                   	pop    %ebp
80101fae:	c3                   	ret    
80101faf:	90                   	nop

80101fb0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101fb0:	f3 0f 1e fb          	endbr32 
80101fb4:	55                   	push   %ebp
80101fb5:	89 e5                	mov    %esp,%ebp
80101fb7:	57                   	push   %edi
80101fb8:	56                   	push   %esi
80101fb9:	53                   	push   %ebx
80101fba:	83 ec 1c             	sub    $0x1c,%esp
80101fbd:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101fc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fc3:	8b 75 10             	mov    0x10(%ebp),%esi
80101fc6:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101fc9:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101fcc:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101fd1:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101fd4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101fd7:	0f 84 a3 00 00 00    	je     80102080 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101fdd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101fe0:	8b 40 58             	mov    0x58(%eax),%eax
80101fe3:	39 c6                	cmp    %eax,%esi
80101fe5:	0f 87 b6 00 00 00    	ja     801020a1 <readi+0xf1>
80101feb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101fee:	31 c9                	xor    %ecx,%ecx
80101ff0:	89 da                	mov    %ebx,%edx
80101ff2:	01 f2                	add    %esi,%edx
80101ff4:	0f 92 c1             	setb   %cl
80101ff7:	89 cf                	mov    %ecx,%edi
80101ff9:	0f 82 a2 00 00 00    	jb     801020a1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101fff:	89 c1                	mov    %eax,%ecx
80102001:	29 f1                	sub    %esi,%ecx
80102003:	39 d0                	cmp    %edx,%eax
80102005:	0f 43 cb             	cmovae %ebx,%ecx
80102008:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010200b:	85 c9                	test   %ecx,%ecx
8010200d:	74 63                	je     80102072 <readi+0xc2>
8010200f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102010:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102013:	89 f2                	mov    %esi,%edx
80102015:	c1 ea 09             	shr    $0x9,%edx
80102018:	89 d8                	mov    %ebx,%eax
8010201a:	e8 61 f9 ff ff       	call   80101980 <bmap>
8010201f:	83 ec 08             	sub    $0x8,%esp
80102022:	50                   	push   %eax
80102023:	ff 33                	pushl  (%ebx)
80102025:	e8 a6 e0 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010202a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010202d:	b9 00 02 00 00       	mov    $0x200,%ecx
80102032:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102035:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102037:	89 f0                	mov    %esi,%eax
80102039:	25 ff 01 00 00       	and    $0x1ff,%eax
8010203e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102040:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102043:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102045:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102049:	39 d9                	cmp    %ebx,%ecx
8010204b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010204e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010204f:	01 df                	add    %ebx,%edi
80102051:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80102053:	50                   	push   %eax
80102054:	ff 75 e0             	pushl  -0x20(%ebp)
80102057:	e8 f4 2e 00 00       	call   80104f50 <memmove>
    brelse(bp);
8010205c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010205f:	89 14 24             	mov    %edx,(%esp)
80102062:	e8 89 e1 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102067:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010206a:	83 c4 10             	add    $0x10,%esp
8010206d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80102070:	77 9e                	ja     80102010 <readi+0x60>
  }
  return n;
80102072:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80102075:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102078:	5b                   	pop    %ebx
80102079:	5e                   	pop    %esi
8010207a:	5f                   	pop    %edi
8010207b:	5d                   	pop    %ebp
8010207c:	c3                   	ret    
8010207d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102080:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102084:	66 83 f8 09          	cmp    $0x9,%ax
80102088:	77 17                	ja     801020a1 <readi+0xf1>
8010208a:	8b 04 c5 e0 1e 11 80 	mov    -0x7feee120(,%eax,8),%eax
80102091:	85 c0                	test   %eax,%eax
80102093:	74 0c                	je     801020a1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102095:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102098:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010209b:	5b                   	pop    %ebx
8010209c:	5e                   	pop    %esi
8010209d:	5f                   	pop    %edi
8010209e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010209f:	ff e0                	jmp    *%eax
      return -1;
801020a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020a6:	eb cd                	jmp    80102075 <readi+0xc5>
801020a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020af:	90                   	nop

801020b0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801020b0:	f3 0f 1e fb          	endbr32 
801020b4:	55                   	push   %ebp
801020b5:	89 e5                	mov    %esp,%ebp
801020b7:	57                   	push   %edi
801020b8:	56                   	push   %esi
801020b9:	53                   	push   %ebx
801020ba:	83 ec 1c             	sub    $0x1c,%esp
801020bd:	8b 45 08             	mov    0x8(%ebp),%eax
801020c0:	8b 75 0c             	mov    0xc(%ebp),%esi
801020c3:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020c6:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801020cb:	89 75 dc             	mov    %esi,-0x24(%ebp)
801020ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
801020d1:	8b 75 10             	mov    0x10(%ebp),%esi
801020d4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
801020d7:	0f 84 b3 00 00 00    	je     80102190 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
801020dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
801020e0:	39 70 58             	cmp    %esi,0x58(%eax)
801020e3:	0f 82 e3 00 00 00    	jb     801021cc <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
801020e9:	8b 7d e0             	mov    -0x20(%ebp),%edi
801020ec:	89 f8                	mov    %edi,%eax
801020ee:	01 f0                	add    %esi,%eax
801020f0:	0f 82 d6 00 00 00    	jb     801021cc <writei+0x11c>
801020f6:	3d 00 18 01 00       	cmp    $0x11800,%eax
801020fb:	0f 87 cb 00 00 00    	ja     801021cc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102101:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102108:	85 ff                	test   %edi,%edi
8010210a:	74 75                	je     80102181 <writei+0xd1>
8010210c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102110:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102113:	89 f2                	mov    %esi,%edx
80102115:	c1 ea 09             	shr    $0x9,%edx
80102118:	89 f8                	mov    %edi,%eax
8010211a:	e8 61 f8 ff ff       	call   80101980 <bmap>
8010211f:	83 ec 08             	sub    $0x8,%esp
80102122:	50                   	push   %eax
80102123:	ff 37                	pushl  (%edi)
80102125:	e8 a6 df ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010212a:	b9 00 02 00 00       	mov    $0x200,%ecx
8010212f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102132:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102135:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80102137:	89 f0                	mov    %esi,%eax
80102139:	83 c4 0c             	add    $0xc,%esp
8010213c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102141:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102143:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102147:	39 d9                	cmp    %ebx,%ecx
80102149:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010214c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010214d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
8010214f:	ff 75 dc             	pushl  -0x24(%ebp)
80102152:	50                   	push   %eax
80102153:	e8 f8 2d 00 00       	call   80104f50 <memmove>
    log_write(bp);
80102158:	89 3c 24             	mov    %edi,(%esp)
8010215b:	e8 00 13 00 00       	call   80103460 <log_write>
    brelse(bp);
80102160:	89 3c 24             	mov    %edi,(%esp)
80102163:	e8 88 e0 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102168:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010216b:	83 c4 10             	add    $0x10,%esp
8010216e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102171:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102174:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80102177:	77 97                	ja     80102110 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102179:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010217c:	3b 70 58             	cmp    0x58(%eax),%esi
8010217f:	77 37                	ja     801021b8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102181:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102184:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102187:	5b                   	pop    %ebx
80102188:	5e                   	pop    %esi
80102189:	5f                   	pop    %edi
8010218a:	5d                   	pop    %ebp
8010218b:	c3                   	ret    
8010218c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102190:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102194:	66 83 f8 09          	cmp    $0x9,%ax
80102198:	77 32                	ja     801021cc <writei+0x11c>
8010219a:	8b 04 c5 e4 1e 11 80 	mov    -0x7feee11c(,%eax,8),%eax
801021a1:	85 c0                	test   %eax,%eax
801021a3:	74 27                	je     801021cc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
801021a5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801021a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021ab:	5b                   	pop    %ebx
801021ac:	5e                   	pop    %esi
801021ad:	5f                   	pop    %edi
801021ae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
801021af:	ff e0                	jmp    *%eax
801021b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
801021b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
801021bb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
801021be:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
801021c1:	50                   	push   %eax
801021c2:	e8 29 fa ff ff       	call   80101bf0 <iupdate>
801021c7:	83 c4 10             	add    $0x10,%esp
801021ca:	eb b5                	jmp    80102181 <writei+0xd1>
      return -1;
801021cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021d1:	eb b1                	jmp    80102184 <writei+0xd4>
801021d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801021e0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021e0:	f3 0f 1e fb          	endbr32 
801021e4:	55                   	push   %ebp
801021e5:	89 e5                	mov    %esp,%ebp
801021e7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801021ea:	6a 0e                	push   $0xe
801021ec:	ff 75 0c             	pushl  0xc(%ebp)
801021ef:	ff 75 08             	pushl  0x8(%ebp)
801021f2:	e8 c9 2d 00 00       	call   80104fc0 <strncmp>
}
801021f7:	c9                   	leave  
801021f8:	c3                   	ret    
801021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102200 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102200:	f3 0f 1e fb          	endbr32 
80102204:	55                   	push   %ebp
80102205:	89 e5                	mov    %esp,%ebp
80102207:	57                   	push   %edi
80102208:	56                   	push   %esi
80102209:	53                   	push   %ebx
8010220a:	83 ec 1c             	sub    $0x1c,%esp
8010220d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102210:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102215:	0f 85 89 00 00 00    	jne    801022a4 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010221b:	8b 53 58             	mov    0x58(%ebx),%edx
8010221e:	31 ff                	xor    %edi,%edi
80102220:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102223:	85 d2                	test   %edx,%edx
80102225:	74 42                	je     80102269 <dirlookup+0x69>
80102227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010222e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102230:	6a 10                	push   $0x10
80102232:	57                   	push   %edi
80102233:	56                   	push   %esi
80102234:	53                   	push   %ebx
80102235:	e8 76 fd ff ff       	call   80101fb0 <readi>
8010223a:	83 c4 10             	add    $0x10,%esp
8010223d:	83 f8 10             	cmp    $0x10,%eax
80102240:	75 55                	jne    80102297 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80102242:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102247:	74 18                	je     80102261 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80102249:	83 ec 04             	sub    $0x4,%esp
8010224c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010224f:	6a 0e                	push   $0xe
80102251:	50                   	push   %eax
80102252:	ff 75 0c             	pushl  0xc(%ebp)
80102255:	e8 66 2d 00 00       	call   80104fc0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
8010225a:	83 c4 10             	add    $0x10,%esp
8010225d:	85 c0                	test   %eax,%eax
8010225f:	74 17                	je     80102278 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102261:	83 c7 10             	add    $0x10,%edi
80102264:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102267:	72 c7                	jb     80102230 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102269:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010226c:	31 c0                	xor    %eax,%eax
}
8010226e:	5b                   	pop    %ebx
8010226f:	5e                   	pop    %esi
80102270:	5f                   	pop    %edi
80102271:	5d                   	pop    %ebp
80102272:	c3                   	ret    
80102273:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102277:	90                   	nop
      if(poff)
80102278:	8b 45 10             	mov    0x10(%ebp),%eax
8010227b:	85 c0                	test   %eax,%eax
8010227d:	74 05                	je     80102284 <dirlookup+0x84>
        *poff = off;
8010227f:	8b 45 10             	mov    0x10(%ebp),%eax
80102282:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80102284:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102288:	8b 03                	mov    (%ebx),%eax
8010228a:	e8 01 f6 ff ff       	call   80101890 <iget>
}
8010228f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102292:	5b                   	pop    %ebx
80102293:	5e                   	pop    %esi
80102294:	5f                   	pop    %edi
80102295:	5d                   	pop    %ebp
80102296:	c3                   	ret    
      panic("dirlookup read");
80102297:	83 ec 0c             	sub    $0xc,%esp
8010229a:	68 59 7c 10 80       	push   $0x80107c59
8010229f:	e8 ec e0 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
801022a4:	83 ec 0c             	sub    $0xc,%esp
801022a7:	68 47 7c 10 80       	push   $0x80107c47
801022ac:	e8 df e0 ff ff       	call   80100390 <panic>
801022b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022bf:	90                   	nop

801022c0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	57                   	push   %edi
801022c4:	56                   	push   %esi
801022c5:	53                   	push   %ebx
801022c6:	89 c3                	mov    %eax,%ebx
801022c8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
801022cb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
801022ce:	89 55 e0             	mov    %edx,-0x20(%ebp)
801022d1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
801022d4:	0f 84 86 01 00 00    	je     80102460 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801022da:	e8 01 1c 00 00       	call   80103ee0 <myproc>
  acquire(&icache.lock);
801022df:	83 ec 0c             	sub    $0xc,%esp
801022e2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
801022e4:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
801022e7:	68 60 1f 11 80       	push   $0x80111f60
801022ec:	e8 af 2a 00 00       	call   80104da0 <acquire>
  ip->ref++;
801022f1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801022f5:	c7 04 24 60 1f 11 80 	movl   $0x80111f60,(%esp)
801022fc:	e8 5f 2b 00 00       	call   80104e60 <release>
80102301:	83 c4 10             	add    $0x10,%esp
80102304:	eb 0d                	jmp    80102313 <namex+0x53>
80102306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010230d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80102310:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80102313:	0f b6 07             	movzbl (%edi),%eax
80102316:	3c 2f                	cmp    $0x2f,%al
80102318:	74 f6                	je     80102310 <namex+0x50>
  if(*path == 0)
8010231a:	84 c0                	test   %al,%al
8010231c:	0f 84 ee 00 00 00    	je     80102410 <namex+0x150>
  while(*path != '/' && *path != 0)
80102322:	0f b6 07             	movzbl (%edi),%eax
80102325:	84 c0                	test   %al,%al
80102327:	0f 84 fb 00 00 00    	je     80102428 <namex+0x168>
8010232d:	89 fb                	mov    %edi,%ebx
8010232f:	3c 2f                	cmp    $0x2f,%al
80102331:	0f 84 f1 00 00 00    	je     80102428 <namex+0x168>
80102337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010233e:	66 90                	xchg   %ax,%ax
80102340:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80102344:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80102347:	3c 2f                	cmp    $0x2f,%al
80102349:	74 04                	je     8010234f <namex+0x8f>
8010234b:	84 c0                	test   %al,%al
8010234d:	75 f1                	jne    80102340 <namex+0x80>
  len = path - s;
8010234f:	89 d8                	mov    %ebx,%eax
80102351:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80102353:	83 f8 0d             	cmp    $0xd,%eax
80102356:	0f 8e 84 00 00 00    	jle    801023e0 <namex+0x120>
    memmove(name, s, DIRSIZ);
8010235c:	83 ec 04             	sub    $0x4,%esp
8010235f:	6a 0e                	push   $0xe
80102361:	57                   	push   %edi
    path++;
80102362:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80102364:	ff 75 e4             	pushl  -0x1c(%ebp)
80102367:	e8 e4 2b 00 00       	call   80104f50 <memmove>
8010236c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010236f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102372:	75 0c                	jne    80102380 <namex+0xc0>
80102374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102378:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
8010237b:	80 3f 2f             	cmpb   $0x2f,(%edi)
8010237e:	74 f8                	je     80102378 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	56                   	push   %esi
80102384:	e8 27 f9 ff ff       	call   80101cb0 <ilock>
    if(ip->type != T_DIR){
80102389:	83 c4 10             	add    $0x10,%esp
8010238c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102391:	0f 85 a1 00 00 00    	jne    80102438 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102397:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010239a:	85 d2                	test   %edx,%edx
8010239c:	74 09                	je     801023a7 <namex+0xe7>
8010239e:	80 3f 00             	cmpb   $0x0,(%edi)
801023a1:	0f 84 d9 00 00 00    	je     80102480 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801023a7:	83 ec 04             	sub    $0x4,%esp
801023aa:	6a 00                	push   $0x0
801023ac:	ff 75 e4             	pushl  -0x1c(%ebp)
801023af:	56                   	push   %esi
801023b0:	e8 4b fe ff ff       	call   80102200 <dirlookup>
801023b5:	83 c4 10             	add    $0x10,%esp
801023b8:	89 c3                	mov    %eax,%ebx
801023ba:	85 c0                	test   %eax,%eax
801023bc:	74 7a                	je     80102438 <namex+0x178>
  iunlock(ip);
801023be:	83 ec 0c             	sub    $0xc,%esp
801023c1:	56                   	push   %esi
801023c2:	e8 c9 f9 ff ff       	call   80101d90 <iunlock>
  iput(ip);
801023c7:	89 34 24             	mov    %esi,(%esp)
801023ca:	89 de                	mov    %ebx,%esi
801023cc:	e8 0f fa ff ff       	call   80101de0 <iput>
801023d1:	83 c4 10             	add    $0x10,%esp
801023d4:	e9 3a ff ff ff       	jmp    80102313 <namex+0x53>
801023d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801023e3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
801023e6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
801023e9:	83 ec 04             	sub    $0x4,%esp
801023ec:	50                   	push   %eax
801023ed:	57                   	push   %edi
    name[len] = 0;
801023ee:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
801023f0:	ff 75 e4             	pushl  -0x1c(%ebp)
801023f3:	e8 58 2b 00 00       	call   80104f50 <memmove>
    name[len] = 0;
801023f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801023fb:	83 c4 10             	add    $0x10,%esp
801023fe:	c6 00 00             	movb   $0x0,(%eax)
80102401:	e9 69 ff ff ff       	jmp    8010236f <namex+0xaf>
80102406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010240d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102410:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102413:	85 c0                	test   %eax,%eax
80102415:	0f 85 85 00 00 00    	jne    801024a0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
8010241b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010241e:	89 f0                	mov    %esi,%eax
80102420:	5b                   	pop    %ebx
80102421:	5e                   	pop    %esi
80102422:	5f                   	pop    %edi
80102423:	5d                   	pop    %ebp
80102424:	c3                   	ret    
80102425:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80102428:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010242b:	89 fb                	mov    %edi,%ebx
8010242d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102430:	31 c0                	xor    %eax,%eax
80102432:	eb b5                	jmp    801023e9 <namex+0x129>
80102434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102438:	83 ec 0c             	sub    $0xc,%esp
8010243b:	56                   	push   %esi
8010243c:	e8 4f f9 ff ff       	call   80101d90 <iunlock>
  iput(ip);
80102441:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102444:	31 f6                	xor    %esi,%esi
  iput(ip);
80102446:	e8 95 f9 ff ff       	call   80101de0 <iput>
      return 0;
8010244b:	83 c4 10             	add    $0x10,%esp
}
8010244e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102451:	89 f0                	mov    %esi,%eax
80102453:	5b                   	pop    %ebx
80102454:	5e                   	pop    %esi
80102455:	5f                   	pop    %edi
80102456:	5d                   	pop    %ebp
80102457:	c3                   	ret    
80102458:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010245f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80102460:	ba 01 00 00 00       	mov    $0x1,%edx
80102465:	b8 01 00 00 00       	mov    $0x1,%eax
8010246a:	89 df                	mov    %ebx,%edi
8010246c:	e8 1f f4 ff ff       	call   80101890 <iget>
80102471:	89 c6                	mov    %eax,%esi
80102473:	e9 9b fe ff ff       	jmp    80102313 <namex+0x53>
80102478:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247f:	90                   	nop
      iunlock(ip);
80102480:	83 ec 0c             	sub    $0xc,%esp
80102483:	56                   	push   %esi
80102484:	e8 07 f9 ff ff       	call   80101d90 <iunlock>
      return ip;
80102489:	83 c4 10             	add    $0x10,%esp
}
8010248c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010248f:	89 f0                	mov    %esi,%eax
80102491:	5b                   	pop    %ebx
80102492:	5e                   	pop    %esi
80102493:	5f                   	pop    %edi
80102494:	5d                   	pop    %ebp
80102495:	c3                   	ret    
80102496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010249d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
801024a0:	83 ec 0c             	sub    $0xc,%esp
801024a3:	56                   	push   %esi
    return 0;
801024a4:	31 f6                	xor    %esi,%esi
    iput(ip);
801024a6:	e8 35 f9 ff ff       	call   80101de0 <iput>
    return 0;
801024ab:	83 c4 10             	add    $0x10,%esp
801024ae:	e9 68 ff ff ff       	jmp    8010241b <namex+0x15b>
801024b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801024c0 <dirlink>:
{
801024c0:	f3 0f 1e fb          	endbr32 
801024c4:	55                   	push   %ebp
801024c5:	89 e5                	mov    %esp,%ebp
801024c7:	57                   	push   %edi
801024c8:	56                   	push   %esi
801024c9:	53                   	push   %ebx
801024ca:	83 ec 20             	sub    $0x20,%esp
801024cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801024d0:	6a 00                	push   $0x0
801024d2:	ff 75 0c             	pushl  0xc(%ebp)
801024d5:	53                   	push   %ebx
801024d6:	e8 25 fd ff ff       	call   80102200 <dirlookup>
801024db:	83 c4 10             	add    $0x10,%esp
801024de:	85 c0                	test   %eax,%eax
801024e0:	75 6b                	jne    8010254d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
801024e2:	8b 7b 58             	mov    0x58(%ebx),%edi
801024e5:	8d 75 d8             	lea    -0x28(%ebp),%esi
801024e8:	85 ff                	test   %edi,%edi
801024ea:	74 2d                	je     80102519 <dirlink+0x59>
801024ec:	31 ff                	xor    %edi,%edi
801024ee:	8d 75 d8             	lea    -0x28(%ebp),%esi
801024f1:	eb 0d                	jmp    80102500 <dirlink+0x40>
801024f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024f7:	90                   	nop
801024f8:	83 c7 10             	add    $0x10,%edi
801024fb:	3b 7b 58             	cmp    0x58(%ebx),%edi
801024fe:	73 19                	jae    80102519 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102500:	6a 10                	push   $0x10
80102502:	57                   	push   %edi
80102503:	56                   	push   %esi
80102504:	53                   	push   %ebx
80102505:	e8 a6 fa ff ff       	call   80101fb0 <readi>
8010250a:	83 c4 10             	add    $0x10,%esp
8010250d:	83 f8 10             	cmp    $0x10,%eax
80102510:	75 4e                	jne    80102560 <dirlink+0xa0>
    if(de.inum == 0)
80102512:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102517:	75 df                	jne    801024f8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102519:	83 ec 04             	sub    $0x4,%esp
8010251c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010251f:	6a 0e                	push   $0xe
80102521:	ff 75 0c             	pushl  0xc(%ebp)
80102524:	50                   	push   %eax
80102525:	e8 e6 2a 00 00       	call   80105010 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010252a:	6a 10                	push   $0x10
  de.inum = inum;
8010252c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010252f:	57                   	push   %edi
80102530:	56                   	push   %esi
80102531:	53                   	push   %ebx
  de.inum = inum;
80102532:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102536:	e8 75 fb ff ff       	call   801020b0 <writei>
8010253b:	83 c4 20             	add    $0x20,%esp
8010253e:	83 f8 10             	cmp    $0x10,%eax
80102541:	75 2a                	jne    8010256d <dirlink+0xad>
  return 0;
80102543:	31 c0                	xor    %eax,%eax
}
80102545:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102548:	5b                   	pop    %ebx
80102549:	5e                   	pop    %esi
8010254a:	5f                   	pop    %edi
8010254b:	5d                   	pop    %ebp
8010254c:	c3                   	ret    
    iput(ip);
8010254d:	83 ec 0c             	sub    $0xc,%esp
80102550:	50                   	push   %eax
80102551:	e8 8a f8 ff ff       	call   80101de0 <iput>
    return -1;
80102556:	83 c4 10             	add    $0x10,%esp
80102559:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010255e:	eb e5                	jmp    80102545 <dirlink+0x85>
      panic("dirlink read");
80102560:	83 ec 0c             	sub    $0xc,%esp
80102563:	68 68 7c 10 80       	push   $0x80107c68
80102568:	e8 23 de ff ff       	call   80100390 <panic>
    panic("dirlink");
8010256d:	83 ec 0c             	sub    $0xc,%esp
80102570:	68 7e 82 10 80       	push   $0x8010827e
80102575:	e8 16 de ff ff       	call   80100390 <panic>
8010257a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102580 <namei>:

struct inode*
namei(char *path)
{
80102580:	f3 0f 1e fb          	endbr32 
80102584:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102585:	31 d2                	xor    %edx,%edx
{
80102587:	89 e5                	mov    %esp,%ebp
80102589:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010258c:	8b 45 08             	mov    0x8(%ebp),%eax
8010258f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102592:	e8 29 fd ff ff       	call   801022c0 <namex>
}
80102597:	c9                   	leave  
80102598:	c3                   	ret    
80102599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801025a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801025a0:	f3 0f 1e fb          	endbr32 
801025a4:	55                   	push   %ebp
  return namex(path, 1, name);
801025a5:	ba 01 00 00 00       	mov    $0x1,%edx
{
801025aa:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801025ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025af:	8b 45 08             	mov    0x8(%ebp),%eax
}
801025b2:	5d                   	pop    %ebp
  return namex(path, 1, name);
801025b3:	e9 08 fd ff ff       	jmp    801022c0 <namex>
801025b8:	66 90                	xchg   %ax,%ax
801025ba:	66 90                	xchg   %ax,%ax
801025bc:	66 90                	xchg   %ax,%ax
801025be:	66 90                	xchg   %ax,%ax

801025c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	57                   	push   %edi
801025c4:	56                   	push   %esi
801025c5:	53                   	push   %ebx
801025c6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801025c9:	85 c0                	test   %eax,%eax
801025cb:	0f 84 b4 00 00 00    	je     80102685 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801025d1:	8b 70 08             	mov    0x8(%eax),%esi
801025d4:	89 c3                	mov    %eax,%ebx
801025d6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801025dc:	0f 87 96 00 00 00    	ja     80102678 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025e2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801025e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ee:	66 90                	xchg   %ax,%ax
801025f0:	89 ca                	mov    %ecx,%edx
801025f2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801025f3:	83 e0 c0             	and    $0xffffffc0,%eax
801025f6:	3c 40                	cmp    $0x40,%al
801025f8:	75 f6                	jne    801025f0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025fa:	31 ff                	xor    %edi,%edi
801025fc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102601:	89 f8                	mov    %edi,%eax
80102603:	ee                   	out    %al,(%dx)
80102604:	b8 01 00 00 00       	mov    $0x1,%eax
80102609:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010260e:	ee                   	out    %al,(%dx)
8010260f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102614:	89 f0                	mov    %esi,%eax
80102616:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102617:	89 f0                	mov    %esi,%eax
80102619:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010261e:	c1 f8 08             	sar    $0x8,%eax
80102621:	ee                   	out    %al,(%dx)
80102622:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102627:	89 f8                	mov    %edi,%eax
80102629:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010262a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010262e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102633:	c1 e0 04             	shl    $0x4,%eax
80102636:	83 e0 10             	and    $0x10,%eax
80102639:	83 c8 e0             	or     $0xffffffe0,%eax
8010263c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010263d:	f6 03 04             	testb  $0x4,(%ebx)
80102640:	75 16                	jne    80102658 <idestart+0x98>
80102642:	b8 20 00 00 00       	mov    $0x20,%eax
80102647:	89 ca                	mov    %ecx,%edx
80102649:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010264a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010264d:	5b                   	pop    %ebx
8010264e:	5e                   	pop    %esi
8010264f:	5f                   	pop    %edi
80102650:	5d                   	pop    %ebp
80102651:	c3                   	ret    
80102652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102658:	b8 30 00 00 00       	mov    $0x30,%eax
8010265d:	89 ca                	mov    %ecx,%edx
8010265f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102660:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102665:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102668:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010266d:	fc                   	cld    
8010266e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102670:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102673:	5b                   	pop    %ebx
80102674:	5e                   	pop    %esi
80102675:	5f                   	pop    %edi
80102676:	5d                   	pop    %ebp
80102677:	c3                   	ret    
    panic("incorrect blockno");
80102678:	83 ec 0c             	sub    $0xc,%esp
8010267b:	68 d4 7c 10 80       	push   $0x80107cd4
80102680:	e8 0b dd ff ff       	call   80100390 <panic>
    panic("idestart");
80102685:	83 ec 0c             	sub    $0xc,%esp
80102688:	68 cb 7c 10 80       	push   $0x80107ccb
8010268d:	e8 fe dc ff ff       	call   80100390 <panic>
80102692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801026a0 <ideinit>:
{
801026a0:	f3 0f 1e fb          	endbr32 
801026a4:	55                   	push   %ebp
801026a5:	89 e5                	mov    %esp,%ebp
801026a7:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801026aa:	68 e6 7c 10 80       	push   $0x80107ce6
801026af:	68 a0 b5 10 80       	push   $0x8010b5a0
801026b4:	e8 67 25 00 00       	call   80104c20 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801026b9:	58                   	pop    %eax
801026ba:	a1 80 42 11 80       	mov    0x80114280,%eax
801026bf:	5a                   	pop    %edx
801026c0:	83 e8 01             	sub    $0x1,%eax
801026c3:	50                   	push   %eax
801026c4:	6a 0e                	push   $0xe
801026c6:	e8 b5 02 00 00       	call   80102980 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801026cb:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026ce:	ba f7 01 00 00       	mov    $0x1f7,%edx
801026d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026d7:	90                   	nop
801026d8:	ec                   	in     (%dx),%al
801026d9:	83 e0 c0             	and    $0xffffffc0,%eax
801026dc:	3c 40                	cmp    $0x40,%al
801026de:	75 f8                	jne    801026d8 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026e0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801026e5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801026ea:	ee                   	out    %al,(%dx)
801026eb:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801026f5:	eb 0e                	jmp    80102705 <ideinit+0x65>
801026f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026fe:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102700:	83 e9 01             	sub    $0x1,%ecx
80102703:	74 0f                	je     80102714 <ideinit+0x74>
80102705:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102706:	84 c0                	test   %al,%al
80102708:	74 f6                	je     80102700 <ideinit+0x60>
      havedisk1 = 1;
8010270a:	c7 05 80 b5 10 80 01 	movl   $0x1,0x8010b580
80102711:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102714:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102719:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010271e:	ee                   	out    %al,(%dx)
}
8010271f:	c9                   	leave  
80102720:	c3                   	ret    
80102721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010272f:	90                   	nop

80102730 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102730:	f3 0f 1e fb          	endbr32 
80102734:	55                   	push   %ebp
80102735:	89 e5                	mov    %esp,%ebp
80102737:	57                   	push   %edi
80102738:	56                   	push   %esi
80102739:	53                   	push   %ebx
8010273a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010273d:	68 a0 b5 10 80       	push   $0x8010b5a0
80102742:	e8 59 26 00 00       	call   80104da0 <acquire>

  if((b = idequeue) == 0){
80102747:	8b 1d 84 b5 10 80    	mov    0x8010b584,%ebx
8010274d:	83 c4 10             	add    $0x10,%esp
80102750:	85 db                	test   %ebx,%ebx
80102752:	74 5f                	je     801027b3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102754:	8b 43 58             	mov    0x58(%ebx),%eax
80102757:	a3 84 b5 10 80       	mov    %eax,0x8010b584

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010275c:	8b 33                	mov    (%ebx),%esi
8010275e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102764:	75 2b                	jne    80102791 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102766:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010276b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop
80102770:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102771:	89 c1                	mov    %eax,%ecx
80102773:	83 e1 c0             	and    $0xffffffc0,%ecx
80102776:	80 f9 40             	cmp    $0x40,%cl
80102779:	75 f5                	jne    80102770 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010277b:	a8 21                	test   $0x21,%al
8010277d:	75 12                	jne    80102791 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010277f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102782:	b9 80 00 00 00       	mov    $0x80,%ecx
80102787:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010278c:	fc                   	cld    
8010278d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010278f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102791:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102794:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102797:	83 ce 02             	or     $0x2,%esi
8010279a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010279c:	53                   	push   %ebx
8010279d:	e8 be 1e 00 00       	call   80104660 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801027a2:	a1 84 b5 10 80       	mov    0x8010b584,%eax
801027a7:	83 c4 10             	add    $0x10,%esp
801027aa:	85 c0                	test   %eax,%eax
801027ac:	74 05                	je     801027b3 <ideintr+0x83>
    idestart(idequeue);
801027ae:	e8 0d fe ff ff       	call   801025c0 <idestart>
    release(&idelock);
801027b3:	83 ec 0c             	sub    $0xc,%esp
801027b6:	68 a0 b5 10 80       	push   $0x8010b5a0
801027bb:	e8 a0 26 00 00       	call   80104e60 <release>

  release(&idelock);
}
801027c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027c3:	5b                   	pop    %ebx
801027c4:	5e                   	pop    %esi
801027c5:	5f                   	pop    %edi
801027c6:	5d                   	pop    %ebp
801027c7:	c3                   	ret    
801027c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cf:	90                   	nop

801027d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027d0:	f3 0f 1e fb          	endbr32 
801027d4:	55                   	push   %ebp
801027d5:	89 e5                	mov    %esp,%ebp
801027d7:	53                   	push   %ebx
801027d8:	83 ec 10             	sub    $0x10,%esp
801027db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801027de:	8d 43 0c             	lea    0xc(%ebx),%eax
801027e1:	50                   	push   %eax
801027e2:	e8 d9 23 00 00       	call   80104bc0 <holdingsleep>
801027e7:	83 c4 10             	add    $0x10,%esp
801027ea:	85 c0                	test   %eax,%eax
801027ec:	0f 84 cf 00 00 00    	je     801028c1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027f2:	8b 03                	mov    (%ebx),%eax
801027f4:	83 e0 06             	and    $0x6,%eax
801027f7:	83 f8 02             	cmp    $0x2,%eax
801027fa:	0f 84 b4 00 00 00    	je     801028b4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102800:	8b 53 04             	mov    0x4(%ebx),%edx
80102803:	85 d2                	test   %edx,%edx
80102805:	74 0d                	je     80102814 <iderw+0x44>
80102807:	a1 80 b5 10 80       	mov    0x8010b580,%eax
8010280c:	85 c0                	test   %eax,%eax
8010280e:	0f 84 93 00 00 00    	je     801028a7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102814:	83 ec 0c             	sub    $0xc,%esp
80102817:	68 a0 b5 10 80       	push   $0x8010b5a0
8010281c:	e8 7f 25 00 00       	call   80104da0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102821:	a1 84 b5 10 80       	mov    0x8010b584,%eax
  b->qnext = 0;
80102826:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010282d:	83 c4 10             	add    $0x10,%esp
80102830:	85 c0                	test   %eax,%eax
80102832:	74 6c                	je     801028a0 <iderw+0xd0>
80102834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102838:	89 c2                	mov    %eax,%edx
8010283a:	8b 40 58             	mov    0x58(%eax),%eax
8010283d:	85 c0                	test   %eax,%eax
8010283f:	75 f7                	jne    80102838 <iderw+0x68>
80102841:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102844:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102846:	39 1d 84 b5 10 80    	cmp    %ebx,0x8010b584
8010284c:	74 42                	je     80102890 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010284e:	8b 03                	mov    (%ebx),%eax
80102850:	83 e0 06             	and    $0x6,%eax
80102853:	83 f8 02             	cmp    $0x2,%eax
80102856:	74 23                	je     8010287b <iderw+0xab>
80102858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010285f:	90                   	nop
    sleep(b, &idelock);
80102860:	83 ec 08             	sub    $0x8,%esp
80102863:	68 a0 b5 10 80       	push   $0x8010b5a0
80102868:	53                   	push   %ebx
80102869:	e8 32 1c 00 00       	call   801044a0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010286e:	8b 03                	mov    (%ebx),%eax
80102870:	83 c4 10             	add    $0x10,%esp
80102873:	83 e0 06             	and    $0x6,%eax
80102876:	83 f8 02             	cmp    $0x2,%eax
80102879:	75 e5                	jne    80102860 <iderw+0x90>
  }


  release(&idelock);
8010287b:	c7 45 08 a0 b5 10 80 	movl   $0x8010b5a0,0x8(%ebp)
}
80102882:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102885:	c9                   	leave  
  release(&idelock);
80102886:	e9 d5 25 00 00       	jmp    80104e60 <release>
8010288b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010288f:	90                   	nop
    idestart(b);
80102890:	89 d8                	mov    %ebx,%eax
80102892:	e8 29 fd ff ff       	call   801025c0 <idestart>
80102897:	eb b5                	jmp    8010284e <iderw+0x7e>
80102899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028a0:	ba 84 b5 10 80       	mov    $0x8010b584,%edx
801028a5:	eb 9d                	jmp    80102844 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
801028a7:	83 ec 0c             	sub    $0xc,%esp
801028aa:	68 15 7d 10 80       	push   $0x80107d15
801028af:	e8 dc da ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
801028b4:	83 ec 0c             	sub    $0xc,%esp
801028b7:	68 00 7d 10 80       	push   $0x80107d00
801028bc:	e8 cf da ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801028c1:	83 ec 0c             	sub    $0xc,%esp
801028c4:	68 ea 7c 10 80       	push   $0x80107cea
801028c9:	e8 c2 da ff ff       	call   80100390 <panic>
801028ce:	66 90                	xchg   %ax,%ax

801028d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801028d0:	f3 0f 1e fb          	endbr32 
801028d4:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801028d5:	c7 05 b4 3b 11 80 00 	movl   $0xfec00000,0x80113bb4
801028dc:	00 c0 fe 
{
801028df:	89 e5                	mov    %esp,%ebp
801028e1:	56                   	push   %esi
801028e2:	53                   	push   %ebx
  ioapic->reg = reg;
801028e3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801028ea:	00 00 00 
  return ioapic->data;
801028ed:	8b 15 b4 3b 11 80    	mov    0x80113bb4,%edx
801028f3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801028f6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801028fc:	8b 0d b4 3b 11 80    	mov    0x80113bb4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102902:	0f b6 15 e0 3c 11 80 	movzbl 0x80113ce0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102909:	c1 ee 10             	shr    $0x10,%esi
8010290c:	89 f0                	mov    %esi,%eax
8010290e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102911:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102914:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102917:	39 c2                	cmp    %eax,%edx
80102919:	74 16                	je     80102931 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010291b:	83 ec 0c             	sub    $0xc,%esp
8010291e:	68 34 7d 10 80       	push   $0x80107d34
80102923:	e8 88 dd ff ff       	call   801006b0 <cprintf>
80102928:	8b 0d b4 3b 11 80    	mov    0x80113bb4,%ecx
8010292e:	83 c4 10             	add    $0x10,%esp
80102931:	83 c6 21             	add    $0x21,%esi
{
80102934:	ba 10 00 00 00       	mov    $0x10,%edx
80102939:	b8 20 00 00 00       	mov    $0x20,%eax
8010293e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102940:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102942:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102944:	8b 0d b4 3b 11 80    	mov    0x80113bb4,%ecx
8010294a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010294d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102953:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102956:	8d 5a 01             	lea    0x1(%edx),%ebx
80102959:	83 c2 02             	add    $0x2,%edx
8010295c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010295e:	8b 0d b4 3b 11 80    	mov    0x80113bb4,%ecx
80102964:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010296b:	39 f0                	cmp    %esi,%eax
8010296d:	75 d1                	jne    80102940 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010296f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102972:	5b                   	pop    %ebx
80102973:	5e                   	pop    %esi
80102974:	5d                   	pop    %ebp
80102975:	c3                   	ret    
80102976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010297d:	8d 76 00             	lea    0x0(%esi),%esi

80102980 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102980:	f3 0f 1e fb          	endbr32 
80102984:	55                   	push   %ebp
  ioapic->reg = reg;
80102985:	8b 0d b4 3b 11 80    	mov    0x80113bb4,%ecx
{
8010298b:	89 e5                	mov    %esp,%ebp
8010298d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102990:	8d 50 20             	lea    0x20(%eax),%edx
80102993:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102997:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102999:	8b 0d b4 3b 11 80    	mov    0x80113bb4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010299f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801029a2:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801029a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801029a8:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801029aa:	a1 b4 3b 11 80       	mov    0x80113bb4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801029af:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801029b2:	89 50 10             	mov    %edx,0x10(%eax)
}
801029b5:	5d                   	pop    %ebp
801029b6:	c3                   	ret    
801029b7:	66 90                	xchg   %ax,%ax
801029b9:	66 90                	xchg   %ax,%ax
801029bb:	66 90                	xchg   %ax,%ax
801029bd:	66 90                	xchg   %ax,%ax
801029bf:	90                   	nop

801029c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801029c0:	f3 0f 1e fb          	endbr32 
801029c4:	55                   	push   %ebp
801029c5:	89 e5                	mov    %esp,%ebp
801029c7:	53                   	push   %ebx
801029c8:	83 ec 04             	sub    $0x4,%esp
801029cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801029ce:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801029d4:	75 7a                	jne    80102a50 <kfree+0x90>
801029d6:	81 fb e8 86 11 80    	cmp    $0x801186e8,%ebx
801029dc:	72 72                	jb     80102a50 <kfree+0x90>
801029de:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801029e4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801029e9:	77 65                	ja     80102a50 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801029eb:	83 ec 04             	sub    $0x4,%esp
801029ee:	68 00 10 00 00       	push   $0x1000
801029f3:	6a 01                	push   $0x1
801029f5:	53                   	push   %ebx
801029f6:	e8 b5 24 00 00       	call   80104eb0 <memset>

  if(kmem.use_lock)
801029fb:	8b 15 f4 3b 11 80    	mov    0x80113bf4,%edx
80102a01:	83 c4 10             	add    $0x10,%esp
80102a04:	85 d2                	test   %edx,%edx
80102a06:	75 20                	jne    80102a28 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102a08:	a1 f8 3b 11 80       	mov    0x80113bf8,%eax
80102a0d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102a0f:	a1 f4 3b 11 80       	mov    0x80113bf4,%eax
  kmem.freelist = r;
80102a14:	89 1d f8 3b 11 80    	mov    %ebx,0x80113bf8
  if(kmem.use_lock)
80102a1a:	85 c0                	test   %eax,%eax
80102a1c:	75 22                	jne    80102a40 <kfree+0x80>
    release(&kmem.lock);
}
80102a1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a21:	c9                   	leave  
80102a22:	c3                   	ret    
80102a23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a27:	90                   	nop
    acquire(&kmem.lock);
80102a28:	83 ec 0c             	sub    $0xc,%esp
80102a2b:	68 c0 3b 11 80       	push   $0x80113bc0
80102a30:	e8 6b 23 00 00       	call   80104da0 <acquire>
80102a35:	83 c4 10             	add    $0x10,%esp
80102a38:	eb ce                	jmp    80102a08 <kfree+0x48>
80102a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102a40:	c7 45 08 c0 3b 11 80 	movl   $0x80113bc0,0x8(%ebp)
}
80102a47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a4a:	c9                   	leave  
    release(&kmem.lock);
80102a4b:	e9 10 24 00 00       	jmp    80104e60 <release>
    panic("kfree");
80102a50:	83 ec 0c             	sub    $0xc,%esp
80102a53:	68 66 7d 10 80       	push   $0x80107d66
80102a58:	e8 33 d9 ff ff       	call   80100390 <panic>
80102a5d:	8d 76 00             	lea    0x0(%esi),%esi

80102a60 <freerange>:
{
80102a60:	f3 0f 1e fb          	endbr32 
80102a64:	55                   	push   %ebp
80102a65:	89 e5                	mov    %esp,%ebp
80102a67:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a68:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a6b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102a6e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a6f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a75:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a7b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a81:	39 de                	cmp    %ebx,%esi
80102a83:	72 1f                	jb     80102aa4 <freerange+0x44>
80102a85:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102a88:	83 ec 0c             	sub    $0xc,%esp
80102a8b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a91:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a97:	50                   	push   %eax
80102a98:	e8 23 ff ff ff       	call   801029c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a9d:	83 c4 10             	add    $0x10,%esp
80102aa0:	39 f3                	cmp    %esi,%ebx
80102aa2:	76 e4                	jbe    80102a88 <freerange+0x28>
}
80102aa4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102aa7:	5b                   	pop    %ebx
80102aa8:	5e                   	pop    %esi
80102aa9:	5d                   	pop    %ebp
80102aaa:	c3                   	ret    
80102aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102aaf:	90                   	nop

80102ab0 <kinit1>:
{
80102ab0:	f3 0f 1e fb          	endbr32 
80102ab4:	55                   	push   %ebp
80102ab5:	89 e5                	mov    %esp,%ebp
80102ab7:	56                   	push   %esi
80102ab8:	53                   	push   %ebx
80102ab9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102abc:	83 ec 08             	sub    $0x8,%esp
80102abf:	68 6c 7d 10 80       	push   $0x80107d6c
80102ac4:	68 c0 3b 11 80       	push   $0x80113bc0
80102ac9:	e8 52 21 00 00       	call   80104c20 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102ace:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ad1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102ad4:	c7 05 f4 3b 11 80 00 	movl   $0x0,0x80113bf4
80102adb:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102ade:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102ae4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102aea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102af0:	39 de                	cmp    %ebx,%esi
80102af2:	72 20                	jb     80102b14 <kinit1+0x64>
80102af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102af8:	83 ec 0c             	sub    $0xc,%esp
80102afb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b01:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102b07:	50                   	push   %eax
80102b08:	e8 b3 fe ff ff       	call   801029c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b0d:	83 c4 10             	add    $0x10,%esp
80102b10:	39 de                	cmp    %ebx,%esi
80102b12:	73 e4                	jae    80102af8 <kinit1+0x48>
}
80102b14:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b17:	5b                   	pop    %ebx
80102b18:	5e                   	pop    %esi
80102b19:	5d                   	pop    %ebp
80102b1a:	c3                   	ret    
80102b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b1f:	90                   	nop

80102b20 <kinit2>:
{
80102b20:	f3 0f 1e fb          	endbr32 
80102b24:	55                   	push   %ebp
80102b25:	89 e5                	mov    %esp,%ebp
80102b27:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102b28:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102b2b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102b2e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102b2f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102b35:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b3b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102b41:	39 de                	cmp    %ebx,%esi
80102b43:	72 1f                	jb     80102b64 <kinit2+0x44>
80102b45:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102b48:	83 ec 0c             	sub    $0xc,%esp
80102b4b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b51:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102b57:	50                   	push   %eax
80102b58:	e8 63 fe ff ff       	call   801029c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b5d:	83 c4 10             	add    $0x10,%esp
80102b60:	39 de                	cmp    %ebx,%esi
80102b62:	73 e4                	jae    80102b48 <kinit2+0x28>
  kmem.use_lock = 1;
80102b64:	c7 05 f4 3b 11 80 01 	movl   $0x1,0x80113bf4
80102b6b:	00 00 00 
}
80102b6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b71:	5b                   	pop    %ebx
80102b72:	5e                   	pop    %esi
80102b73:	5d                   	pop    %ebp
80102b74:	c3                   	ret    
80102b75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b80 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b80:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102b84:	a1 f4 3b 11 80       	mov    0x80113bf4,%eax
80102b89:	85 c0                	test   %eax,%eax
80102b8b:	75 1b                	jne    80102ba8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102b8d:	a1 f8 3b 11 80       	mov    0x80113bf8,%eax
  if(r)
80102b92:	85 c0                	test   %eax,%eax
80102b94:	74 0a                	je     80102ba0 <kalloc+0x20>
    kmem.freelist = r->next;
80102b96:	8b 10                	mov    (%eax),%edx
80102b98:	89 15 f8 3b 11 80    	mov    %edx,0x80113bf8
  if(kmem.use_lock)
80102b9e:	c3                   	ret    
80102b9f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102ba0:	c3                   	ret    
80102ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102ba8:	55                   	push   %ebp
80102ba9:	89 e5                	mov    %esp,%ebp
80102bab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102bae:	68 c0 3b 11 80       	push   $0x80113bc0
80102bb3:	e8 e8 21 00 00       	call   80104da0 <acquire>
  r = kmem.freelist;
80102bb8:	a1 f8 3b 11 80       	mov    0x80113bf8,%eax
  if(r)
80102bbd:	8b 15 f4 3b 11 80    	mov    0x80113bf4,%edx
80102bc3:	83 c4 10             	add    $0x10,%esp
80102bc6:	85 c0                	test   %eax,%eax
80102bc8:	74 08                	je     80102bd2 <kalloc+0x52>
    kmem.freelist = r->next;
80102bca:	8b 08                	mov    (%eax),%ecx
80102bcc:	89 0d f8 3b 11 80    	mov    %ecx,0x80113bf8
  if(kmem.use_lock)
80102bd2:	85 d2                	test   %edx,%edx
80102bd4:	74 16                	je     80102bec <kalloc+0x6c>
    release(&kmem.lock);
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102bdc:	68 c0 3b 11 80       	push   $0x80113bc0
80102be1:	e8 7a 22 00 00       	call   80104e60 <release>
  return (char*)r;
80102be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102be9:	83 c4 10             	add    $0x10,%esp
}
80102bec:	c9                   	leave  
80102bed:	c3                   	ret    
80102bee:	66 90                	xchg   %ax,%ax

80102bf0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102bf0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf4:	ba 64 00 00 00       	mov    $0x64,%edx
80102bf9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102bfa:	a8 01                	test   $0x1,%al
80102bfc:	0f 84 be 00 00 00    	je     80102cc0 <kbdgetc+0xd0>
{
80102c02:	55                   	push   %ebp
80102c03:	ba 60 00 00 00       	mov    $0x60,%edx
80102c08:	89 e5                	mov    %esp,%ebp
80102c0a:	53                   	push   %ebx
80102c0b:	ec                   	in     (%dx),%al
  return data;
80102c0c:	8b 1d d4 b5 10 80    	mov    0x8010b5d4,%ebx
    return -1;
  data = inb(KBDATAP);
80102c12:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102c15:	3c e0                	cmp    $0xe0,%al
80102c17:	74 57                	je     80102c70 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102c19:	89 d9                	mov    %ebx,%ecx
80102c1b:	83 e1 40             	and    $0x40,%ecx
80102c1e:	84 c0                	test   %al,%al
80102c20:	78 5e                	js     80102c80 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102c22:	85 c9                	test   %ecx,%ecx
80102c24:	74 09                	je     80102c2f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c26:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102c29:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102c2c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102c2f:	0f b6 8a a0 7e 10 80 	movzbl -0x7fef8160(%edx),%ecx
  shift ^= togglecode[data];
80102c36:	0f b6 82 a0 7d 10 80 	movzbl -0x7fef8260(%edx),%eax
  shift |= shiftcode[data];
80102c3d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102c3f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102c41:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102c43:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
  c = charcode[shift & (CTL | SHIFT)][data];
80102c49:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102c4c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102c4f:	8b 04 85 80 7d 10 80 	mov    -0x7fef8280(,%eax,4),%eax
80102c56:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102c5a:	74 0b                	je     80102c67 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102c5c:	8d 50 9f             	lea    -0x61(%eax),%edx
80102c5f:	83 fa 19             	cmp    $0x19,%edx
80102c62:	77 44                	ja     80102ca8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102c64:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102c67:	5b                   	pop    %ebx
80102c68:	5d                   	pop    %ebp
80102c69:	c3                   	ret    
80102c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102c70:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102c73:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102c75:	89 1d d4 b5 10 80    	mov    %ebx,0x8010b5d4
}
80102c7b:	5b                   	pop    %ebx
80102c7c:	5d                   	pop    %ebp
80102c7d:	c3                   	ret    
80102c7e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102c80:	83 e0 7f             	and    $0x7f,%eax
80102c83:	85 c9                	test   %ecx,%ecx
80102c85:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102c88:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102c8a:	0f b6 8a a0 7e 10 80 	movzbl -0x7fef8160(%edx),%ecx
80102c91:	83 c9 40             	or     $0x40,%ecx
80102c94:	0f b6 c9             	movzbl %cl,%ecx
80102c97:	f7 d1                	not    %ecx
80102c99:	21 d9                	and    %ebx,%ecx
}
80102c9b:	5b                   	pop    %ebx
80102c9c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102c9d:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
}
80102ca3:	c3                   	ret    
80102ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102ca8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102cab:	8d 50 20             	lea    0x20(%eax),%edx
}
80102cae:	5b                   	pop    %ebx
80102caf:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102cb0:	83 f9 1a             	cmp    $0x1a,%ecx
80102cb3:	0f 42 c2             	cmovb  %edx,%eax
}
80102cb6:	c3                   	ret    
80102cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cbe:	66 90                	xchg   %ax,%ax
    return -1;
80102cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102cc5:	c3                   	ret    
80102cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ccd:	8d 76 00             	lea    0x0(%esi),%esi

80102cd0 <kbdintr>:

void
kbdintr(void)
{
80102cd0:	f3 0f 1e fb          	endbr32 
80102cd4:	55                   	push   %ebp
80102cd5:	89 e5                	mov    %esp,%ebp
80102cd7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102cda:	68 f0 2b 10 80       	push   $0x80102bf0
80102cdf:	e8 3c df ff ff       	call   80100c20 <consoleintr>
}
80102ce4:	83 c4 10             	add    $0x10,%esp
80102ce7:	c9                   	leave  
80102ce8:	c3                   	ret    
80102ce9:	66 90                	xchg   %ax,%ax
80102ceb:	66 90                	xchg   %ax,%ax
80102ced:	66 90                	xchg   %ax,%ax
80102cef:	90                   	nop

80102cf0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102cf0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102cf4:	a1 fc 3b 11 80       	mov    0x80113bfc,%eax
80102cf9:	85 c0                	test   %eax,%eax
80102cfb:	0f 84 c7 00 00 00    	je     80102dc8 <lapicinit+0xd8>
  lapic[index] = value;
80102d01:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102d08:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d0b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d0e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102d15:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d18:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d1b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102d22:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102d25:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d28:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102d2f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102d32:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d35:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102d3c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d3f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d42:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102d49:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d4c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102d4f:	8b 50 30             	mov    0x30(%eax),%edx
80102d52:	c1 ea 10             	shr    $0x10,%edx
80102d55:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102d5b:	75 73                	jne    80102dd0 <lapicinit+0xe0>
  lapic[index] = value;
80102d5d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102d64:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d67:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d6a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d71:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d74:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d77:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d7e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d81:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d84:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102d8b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d8e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d91:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102d98:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d9b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d9e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102da5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102da8:	8b 50 20             	mov    0x20(%eax),%edx
80102dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102daf:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102db0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102db6:	80 e6 10             	and    $0x10,%dh
80102db9:	75 f5                	jne    80102db0 <lapicinit+0xc0>
  lapic[index] = value;
80102dbb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102dc2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102dc5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102dc8:	c3                   	ret    
80102dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102dd0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102dd7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102dda:	8b 50 20             	mov    0x20(%eax),%edx
}
80102ddd:	e9 7b ff ff ff       	jmp    80102d5d <lapicinit+0x6d>
80102de2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102df0 <lapicid>:

int
lapicid(void)
{
80102df0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102df4:	a1 fc 3b 11 80       	mov    0x80113bfc,%eax
80102df9:	85 c0                	test   %eax,%eax
80102dfb:	74 0b                	je     80102e08 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102dfd:	8b 40 20             	mov    0x20(%eax),%eax
80102e00:	c1 e8 18             	shr    $0x18,%eax
80102e03:	c3                   	ret    
80102e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102e08:	31 c0                	xor    %eax,%eax
}
80102e0a:	c3                   	ret    
80102e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e0f:	90                   	nop

80102e10 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102e10:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102e14:	a1 fc 3b 11 80       	mov    0x80113bfc,%eax
80102e19:	85 c0                	test   %eax,%eax
80102e1b:	74 0d                	je     80102e2a <lapiceoi+0x1a>
  lapic[index] = value;
80102e1d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102e24:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e27:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102e2a:	c3                   	ret    
80102e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e2f:	90                   	nop

80102e30 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102e30:	f3 0f 1e fb          	endbr32 
}
80102e34:	c3                   	ret    
80102e35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102e40 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102e40:	f3 0f 1e fb          	endbr32 
80102e44:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e45:	b8 0f 00 00 00       	mov    $0xf,%eax
80102e4a:	ba 70 00 00 00       	mov    $0x70,%edx
80102e4f:	89 e5                	mov    %esp,%ebp
80102e51:	53                   	push   %ebx
80102e52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102e55:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e58:	ee                   	out    %al,(%dx)
80102e59:	b8 0a 00 00 00       	mov    $0xa,%eax
80102e5e:	ba 71 00 00 00       	mov    $0x71,%edx
80102e63:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102e64:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102e66:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102e69:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102e6f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102e71:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102e74:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102e76:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102e79:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102e7c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102e82:	a1 fc 3b 11 80       	mov    0x80113bfc,%eax
80102e87:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e8d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e90:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102e97:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e9a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e9d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102ea4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ea7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102eaa:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102eb0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102eb3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102eb9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ebc:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ec2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ec5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102ecb:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102ecc:	8b 40 20             	mov    0x20(%eax),%eax
}
80102ecf:	5d                   	pop    %ebp
80102ed0:	c3                   	ret    
80102ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102edf:	90                   	nop

80102ee0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102ee0:	f3 0f 1e fb          	endbr32 
80102ee4:	55                   	push   %ebp
80102ee5:	b8 0b 00 00 00       	mov    $0xb,%eax
80102eea:	ba 70 00 00 00       	mov    $0x70,%edx
80102eef:	89 e5                	mov    %esp,%ebp
80102ef1:	57                   	push   %edi
80102ef2:	56                   	push   %esi
80102ef3:	53                   	push   %ebx
80102ef4:	83 ec 4c             	sub    $0x4c,%esp
80102ef7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ef8:	ba 71 00 00 00       	mov    $0x71,%edx
80102efd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102efe:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f01:	bb 70 00 00 00       	mov    $0x70,%ebx
80102f06:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f10:	31 c0                	xor    %eax,%eax
80102f12:	89 da                	mov    %ebx,%edx
80102f14:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f15:	b9 71 00 00 00       	mov    $0x71,%ecx
80102f1a:	89 ca                	mov    %ecx,%edx
80102f1c:	ec                   	in     (%dx),%al
80102f1d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f20:	89 da                	mov    %ebx,%edx
80102f22:	b8 02 00 00 00       	mov    $0x2,%eax
80102f27:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f28:	89 ca                	mov    %ecx,%edx
80102f2a:	ec                   	in     (%dx),%al
80102f2b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f2e:	89 da                	mov    %ebx,%edx
80102f30:	b8 04 00 00 00       	mov    $0x4,%eax
80102f35:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f36:	89 ca                	mov    %ecx,%edx
80102f38:	ec                   	in     (%dx),%al
80102f39:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f3c:	89 da                	mov    %ebx,%edx
80102f3e:	b8 07 00 00 00       	mov    $0x7,%eax
80102f43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f44:	89 ca                	mov    %ecx,%edx
80102f46:	ec                   	in     (%dx),%al
80102f47:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f4a:	89 da                	mov    %ebx,%edx
80102f4c:	b8 08 00 00 00       	mov    $0x8,%eax
80102f51:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f52:	89 ca                	mov    %ecx,%edx
80102f54:	ec                   	in     (%dx),%al
80102f55:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f57:	89 da                	mov    %ebx,%edx
80102f59:	b8 09 00 00 00       	mov    $0x9,%eax
80102f5e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f5f:	89 ca                	mov    %ecx,%edx
80102f61:	ec                   	in     (%dx),%al
80102f62:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f64:	89 da                	mov    %ebx,%edx
80102f66:	b8 0a 00 00 00       	mov    $0xa,%eax
80102f6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f6c:	89 ca                	mov    %ecx,%edx
80102f6e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102f6f:	84 c0                	test   %al,%al
80102f71:	78 9d                	js     80102f10 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102f73:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102f77:	89 fa                	mov    %edi,%edx
80102f79:	0f b6 fa             	movzbl %dl,%edi
80102f7c:	89 f2                	mov    %esi,%edx
80102f7e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102f81:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102f85:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f88:	89 da                	mov    %ebx,%edx
80102f8a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102f8d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102f90:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102f94:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102f97:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102f9a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102f9e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102fa1:	31 c0                	xor    %eax,%eax
80102fa3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fa4:	89 ca                	mov    %ecx,%edx
80102fa6:	ec                   	in     (%dx),%al
80102fa7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102faa:	89 da                	mov    %ebx,%edx
80102fac:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102faf:	b8 02 00 00 00       	mov    $0x2,%eax
80102fb4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fb5:	89 ca                	mov    %ecx,%edx
80102fb7:	ec                   	in     (%dx),%al
80102fb8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fbb:	89 da                	mov    %ebx,%edx
80102fbd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102fc0:	b8 04 00 00 00       	mov    $0x4,%eax
80102fc5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fc6:	89 ca                	mov    %ecx,%edx
80102fc8:	ec                   	in     (%dx),%al
80102fc9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fcc:	89 da                	mov    %ebx,%edx
80102fce:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102fd1:	b8 07 00 00 00       	mov    $0x7,%eax
80102fd6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fd7:	89 ca                	mov    %ecx,%edx
80102fd9:	ec                   	in     (%dx),%al
80102fda:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fdd:	89 da                	mov    %ebx,%edx
80102fdf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102fe2:	b8 08 00 00 00       	mov    $0x8,%eax
80102fe7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fe8:	89 ca                	mov    %ecx,%edx
80102fea:	ec                   	in     (%dx),%al
80102feb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fee:	89 da                	mov    %ebx,%edx
80102ff0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ff3:	b8 09 00 00 00       	mov    $0x9,%eax
80102ff8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ff9:	89 ca                	mov    %ecx,%edx
80102ffb:	ec                   	in     (%dx),%al
80102ffc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102fff:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103002:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103005:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103008:	6a 18                	push   $0x18
8010300a:	50                   	push   %eax
8010300b:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010300e:	50                   	push   %eax
8010300f:	e8 ec 1e 00 00       	call   80104f00 <memcmp>
80103014:	83 c4 10             	add    $0x10,%esp
80103017:	85 c0                	test   %eax,%eax
80103019:	0f 85 f1 fe ff ff    	jne    80102f10 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
8010301f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103023:	75 78                	jne    8010309d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103025:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103028:	89 c2                	mov    %eax,%edx
8010302a:	83 e0 0f             	and    $0xf,%eax
8010302d:	c1 ea 04             	shr    $0x4,%edx
80103030:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103033:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103036:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103039:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010303c:	89 c2                	mov    %eax,%edx
8010303e:	83 e0 0f             	and    $0xf,%eax
80103041:	c1 ea 04             	shr    $0x4,%edx
80103044:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103047:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010304a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
8010304d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103050:	89 c2                	mov    %eax,%edx
80103052:	83 e0 0f             	and    $0xf,%eax
80103055:	c1 ea 04             	shr    $0x4,%edx
80103058:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010305b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010305e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103061:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103064:	89 c2                	mov    %eax,%edx
80103066:	83 e0 0f             	and    $0xf,%eax
80103069:	c1 ea 04             	shr    $0x4,%edx
8010306c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010306f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103072:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103075:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103078:	89 c2                	mov    %eax,%edx
8010307a:	83 e0 0f             	and    $0xf,%eax
8010307d:	c1 ea 04             	shr    $0x4,%edx
80103080:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103083:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103086:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103089:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010308c:	89 c2                	mov    %eax,%edx
8010308e:	83 e0 0f             	and    $0xf,%eax
80103091:	c1 ea 04             	shr    $0x4,%edx
80103094:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103097:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010309a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010309d:	8b 75 08             	mov    0x8(%ebp),%esi
801030a0:	8b 45 b8             	mov    -0x48(%ebp),%eax
801030a3:	89 06                	mov    %eax,(%esi)
801030a5:	8b 45 bc             	mov    -0x44(%ebp),%eax
801030a8:	89 46 04             	mov    %eax,0x4(%esi)
801030ab:	8b 45 c0             	mov    -0x40(%ebp),%eax
801030ae:	89 46 08             	mov    %eax,0x8(%esi)
801030b1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801030b4:	89 46 0c             	mov    %eax,0xc(%esi)
801030b7:	8b 45 c8             	mov    -0x38(%ebp),%eax
801030ba:	89 46 10             	mov    %eax,0x10(%esi)
801030bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
801030c0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801030c3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801030ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030cd:	5b                   	pop    %ebx
801030ce:	5e                   	pop    %esi
801030cf:	5f                   	pop    %edi
801030d0:	5d                   	pop    %ebp
801030d1:	c3                   	ret    
801030d2:	66 90                	xchg   %ax,%ax
801030d4:	66 90                	xchg   %ax,%ax
801030d6:	66 90                	xchg   %ax,%ax
801030d8:	66 90                	xchg   %ax,%ax
801030da:	66 90                	xchg   %ax,%ax
801030dc:	66 90                	xchg   %ax,%ax
801030de:	66 90                	xchg   %ax,%ax

801030e0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030e0:	8b 0d 48 3c 11 80    	mov    0x80113c48,%ecx
801030e6:	85 c9                	test   %ecx,%ecx
801030e8:	0f 8e 8a 00 00 00    	jle    80103178 <install_trans+0x98>
{
801030ee:	55                   	push   %ebp
801030ef:	89 e5                	mov    %esp,%ebp
801030f1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
801030f2:	31 ff                	xor    %edi,%edi
{
801030f4:	56                   	push   %esi
801030f5:	53                   	push   %ebx
801030f6:	83 ec 0c             	sub    $0xc,%esp
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103100:	a1 34 3c 11 80       	mov    0x80113c34,%eax
80103105:	83 ec 08             	sub    $0x8,%esp
80103108:	01 f8                	add    %edi,%eax
8010310a:	83 c0 01             	add    $0x1,%eax
8010310d:	50                   	push   %eax
8010310e:	ff 35 44 3c 11 80    	pushl  0x80113c44
80103114:	e8 b7 cf ff ff       	call   801000d0 <bread>
80103119:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010311b:	58                   	pop    %eax
8010311c:	5a                   	pop    %edx
8010311d:	ff 34 bd 4c 3c 11 80 	pushl  -0x7feec3b4(,%edi,4)
80103124:	ff 35 44 3c 11 80    	pushl  0x80113c44
  for (tail = 0; tail < log.lh.n; tail++) {
8010312a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010312d:	e8 9e cf ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103132:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103135:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103137:	8d 46 5c             	lea    0x5c(%esi),%eax
8010313a:	68 00 02 00 00       	push   $0x200
8010313f:	50                   	push   %eax
80103140:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103143:	50                   	push   %eax
80103144:	e8 07 1e 00 00       	call   80104f50 <memmove>
    bwrite(dbuf);  // write dst to disk
80103149:	89 1c 24             	mov    %ebx,(%esp)
8010314c:	e8 5f d0 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103151:	89 34 24             	mov    %esi,(%esp)
80103154:	e8 97 d0 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103159:	89 1c 24             	mov    %ebx,(%esp)
8010315c:	e8 8f d0 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103161:	83 c4 10             	add    $0x10,%esp
80103164:	39 3d 48 3c 11 80    	cmp    %edi,0x80113c48
8010316a:	7f 94                	jg     80103100 <install_trans+0x20>
  }
}
8010316c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010316f:	5b                   	pop    %ebx
80103170:	5e                   	pop    %esi
80103171:	5f                   	pop    %edi
80103172:	5d                   	pop    %ebp
80103173:	c3                   	ret    
80103174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103178:	c3                   	ret    
80103179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103180 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	53                   	push   %ebx
80103184:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103187:	ff 35 34 3c 11 80    	pushl  0x80113c34
8010318d:	ff 35 44 3c 11 80    	pushl  0x80113c44
80103193:	e8 38 cf ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103198:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010319b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010319d:	a1 48 3c 11 80       	mov    0x80113c48,%eax
801031a2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801031a5:	85 c0                	test   %eax,%eax
801031a7:	7e 19                	jle    801031c2 <write_head+0x42>
801031a9:	31 d2                	xor    %edx,%edx
801031ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop
    hb->block[i] = log.lh.block[i];
801031b0:	8b 0c 95 4c 3c 11 80 	mov    -0x7feec3b4(,%edx,4),%ecx
801031b7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801031bb:	83 c2 01             	add    $0x1,%edx
801031be:	39 d0                	cmp    %edx,%eax
801031c0:	75 ee                	jne    801031b0 <write_head+0x30>
  }
  bwrite(buf);
801031c2:	83 ec 0c             	sub    $0xc,%esp
801031c5:	53                   	push   %ebx
801031c6:	e8 e5 cf ff ff       	call   801001b0 <bwrite>
  brelse(buf);
801031cb:	89 1c 24             	mov    %ebx,(%esp)
801031ce:	e8 1d d0 ff ff       	call   801001f0 <brelse>
}
801031d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031d6:	83 c4 10             	add    $0x10,%esp
801031d9:	c9                   	leave  
801031da:	c3                   	ret    
801031db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031df:	90                   	nop

801031e0 <initlog>:
{
801031e0:	f3 0f 1e fb          	endbr32 
801031e4:	55                   	push   %ebp
801031e5:	89 e5                	mov    %esp,%ebp
801031e7:	53                   	push   %ebx
801031e8:	83 ec 2c             	sub    $0x2c,%esp
801031eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801031ee:	68 a0 7f 10 80       	push   $0x80107fa0
801031f3:	68 00 3c 11 80       	push   $0x80113c00
801031f8:	e8 23 1a 00 00       	call   80104c20 <initlock>
  readsb(dev, &sb);
801031fd:	58                   	pop    %eax
801031fe:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103201:	5a                   	pop    %edx
80103202:	50                   	push   %eax
80103203:	53                   	push   %ebx
80103204:	e8 47 e8 ff ff       	call   80101a50 <readsb>
  log.start = sb.logstart;
80103209:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010320c:	59                   	pop    %ecx
  log.dev = dev;
8010320d:	89 1d 44 3c 11 80    	mov    %ebx,0x80113c44
  log.size = sb.nlog;
80103213:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103216:	a3 34 3c 11 80       	mov    %eax,0x80113c34
  log.size = sb.nlog;
8010321b:	89 15 38 3c 11 80    	mov    %edx,0x80113c38
  struct buf *buf = bread(log.dev, log.start);
80103221:	5a                   	pop    %edx
80103222:	50                   	push   %eax
80103223:	53                   	push   %ebx
80103224:	e8 a7 ce ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103229:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010322c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010322f:	89 0d 48 3c 11 80    	mov    %ecx,0x80113c48
  for (i = 0; i < log.lh.n; i++) {
80103235:	85 c9                	test   %ecx,%ecx
80103237:	7e 19                	jle    80103252 <initlog+0x72>
80103239:	31 d2                	xor    %edx,%edx
8010323b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010323f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103240:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103244:	89 1c 95 4c 3c 11 80 	mov    %ebx,-0x7feec3b4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010324b:	83 c2 01             	add    $0x1,%edx
8010324e:	39 d1                	cmp    %edx,%ecx
80103250:	75 ee                	jne    80103240 <initlog+0x60>
  brelse(buf);
80103252:	83 ec 0c             	sub    $0xc,%esp
80103255:	50                   	push   %eax
80103256:	e8 95 cf ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010325b:	e8 80 fe ff ff       	call   801030e0 <install_trans>
  log.lh.n = 0;
80103260:	c7 05 48 3c 11 80 00 	movl   $0x0,0x80113c48
80103267:	00 00 00 
  write_head(); // clear the log
8010326a:	e8 11 ff ff ff       	call   80103180 <write_head>
}
8010326f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103272:	83 c4 10             	add    $0x10,%esp
80103275:	c9                   	leave  
80103276:	c3                   	ret    
80103277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010327e:	66 90                	xchg   %ax,%ax

80103280 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103280:	f3 0f 1e fb          	endbr32 
80103284:	55                   	push   %ebp
80103285:	89 e5                	mov    %esp,%ebp
80103287:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010328a:	68 00 3c 11 80       	push   $0x80113c00
8010328f:	e8 0c 1b 00 00       	call   80104da0 <acquire>
80103294:	83 c4 10             	add    $0x10,%esp
80103297:	eb 1c                	jmp    801032b5 <begin_op+0x35>
80103299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801032a0:	83 ec 08             	sub    $0x8,%esp
801032a3:	68 00 3c 11 80       	push   $0x80113c00
801032a8:	68 00 3c 11 80       	push   $0x80113c00
801032ad:	e8 ee 11 00 00       	call   801044a0 <sleep>
801032b2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801032b5:	a1 40 3c 11 80       	mov    0x80113c40,%eax
801032ba:	85 c0                	test   %eax,%eax
801032bc:	75 e2                	jne    801032a0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801032be:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
801032c3:	8b 15 48 3c 11 80    	mov    0x80113c48,%edx
801032c9:	83 c0 01             	add    $0x1,%eax
801032cc:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801032cf:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801032d2:	83 fa 1e             	cmp    $0x1e,%edx
801032d5:	7f c9                	jg     801032a0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801032d7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801032da:	a3 3c 3c 11 80       	mov    %eax,0x80113c3c
      release(&log.lock);
801032df:	68 00 3c 11 80       	push   $0x80113c00
801032e4:	e8 77 1b 00 00       	call   80104e60 <release>
      break;
    }
  }
}
801032e9:	83 c4 10             	add    $0x10,%esp
801032ec:	c9                   	leave  
801032ed:	c3                   	ret    
801032ee:	66 90                	xchg   %ax,%ax

801032f0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801032f0:	f3 0f 1e fb          	endbr32 
801032f4:	55                   	push   %ebp
801032f5:	89 e5                	mov    %esp,%ebp
801032f7:	57                   	push   %edi
801032f8:	56                   	push   %esi
801032f9:	53                   	push   %ebx
801032fa:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801032fd:	68 00 3c 11 80       	push   $0x80113c00
80103302:	e8 99 1a 00 00       	call   80104da0 <acquire>
  log.outstanding -= 1;
80103307:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
  if(log.committing)
8010330c:	8b 35 40 3c 11 80    	mov    0x80113c40,%esi
80103312:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103315:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103318:	89 1d 3c 3c 11 80    	mov    %ebx,0x80113c3c
  if(log.committing)
8010331e:	85 f6                	test   %esi,%esi
80103320:	0f 85 1e 01 00 00    	jne    80103444 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103326:	85 db                	test   %ebx,%ebx
80103328:	0f 85 f2 00 00 00    	jne    80103420 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010332e:	c7 05 40 3c 11 80 01 	movl   $0x1,0x80113c40
80103335:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103338:	83 ec 0c             	sub    $0xc,%esp
8010333b:	68 00 3c 11 80       	push   $0x80113c00
80103340:	e8 1b 1b 00 00       	call   80104e60 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103345:	8b 0d 48 3c 11 80    	mov    0x80113c48,%ecx
8010334b:	83 c4 10             	add    $0x10,%esp
8010334e:	85 c9                	test   %ecx,%ecx
80103350:	7f 3e                	jg     80103390 <end_op+0xa0>
    acquire(&log.lock);
80103352:	83 ec 0c             	sub    $0xc,%esp
80103355:	68 00 3c 11 80       	push   $0x80113c00
8010335a:	e8 41 1a 00 00       	call   80104da0 <acquire>
    wakeup(&log);
8010335f:	c7 04 24 00 3c 11 80 	movl   $0x80113c00,(%esp)
    log.committing = 0;
80103366:	c7 05 40 3c 11 80 00 	movl   $0x0,0x80113c40
8010336d:	00 00 00 
    wakeup(&log);
80103370:	e8 eb 12 00 00       	call   80104660 <wakeup>
    release(&log.lock);
80103375:	c7 04 24 00 3c 11 80 	movl   $0x80113c00,(%esp)
8010337c:	e8 df 1a 00 00       	call   80104e60 <release>
80103381:	83 c4 10             	add    $0x10,%esp
}
80103384:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103387:	5b                   	pop    %ebx
80103388:	5e                   	pop    %esi
80103389:	5f                   	pop    %edi
8010338a:	5d                   	pop    %ebp
8010338b:	c3                   	ret    
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103390:	a1 34 3c 11 80       	mov    0x80113c34,%eax
80103395:	83 ec 08             	sub    $0x8,%esp
80103398:	01 d8                	add    %ebx,%eax
8010339a:	83 c0 01             	add    $0x1,%eax
8010339d:	50                   	push   %eax
8010339e:	ff 35 44 3c 11 80    	pushl  0x80113c44
801033a4:	e8 27 cd ff ff       	call   801000d0 <bread>
801033a9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801033ab:	58                   	pop    %eax
801033ac:	5a                   	pop    %edx
801033ad:	ff 34 9d 4c 3c 11 80 	pushl  -0x7feec3b4(,%ebx,4)
801033b4:	ff 35 44 3c 11 80    	pushl  0x80113c44
  for (tail = 0; tail < log.lh.n; tail++) {
801033ba:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801033bd:	e8 0e cd ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801033c2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801033c5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801033c7:	8d 40 5c             	lea    0x5c(%eax),%eax
801033ca:	68 00 02 00 00       	push   $0x200
801033cf:	50                   	push   %eax
801033d0:	8d 46 5c             	lea    0x5c(%esi),%eax
801033d3:	50                   	push   %eax
801033d4:	e8 77 1b 00 00       	call   80104f50 <memmove>
    bwrite(to);  // write the log
801033d9:	89 34 24             	mov    %esi,(%esp)
801033dc:	e8 cf cd ff ff       	call   801001b0 <bwrite>
    brelse(from);
801033e1:	89 3c 24             	mov    %edi,(%esp)
801033e4:	e8 07 ce ff ff       	call   801001f0 <brelse>
    brelse(to);
801033e9:	89 34 24             	mov    %esi,(%esp)
801033ec:	e8 ff cd ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801033f1:	83 c4 10             	add    $0x10,%esp
801033f4:	3b 1d 48 3c 11 80    	cmp    0x80113c48,%ebx
801033fa:	7c 94                	jl     80103390 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801033fc:	e8 7f fd ff ff       	call   80103180 <write_head>
    install_trans(); // Now install writes to home locations
80103401:	e8 da fc ff ff       	call   801030e0 <install_trans>
    log.lh.n = 0;
80103406:	c7 05 48 3c 11 80 00 	movl   $0x0,0x80113c48
8010340d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103410:	e8 6b fd ff ff       	call   80103180 <write_head>
80103415:	e9 38 ff ff ff       	jmp    80103352 <end_op+0x62>
8010341a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103420:	83 ec 0c             	sub    $0xc,%esp
80103423:	68 00 3c 11 80       	push   $0x80113c00
80103428:	e8 33 12 00 00       	call   80104660 <wakeup>
  release(&log.lock);
8010342d:	c7 04 24 00 3c 11 80 	movl   $0x80113c00,(%esp)
80103434:	e8 27 1a 00 00       	call   80104e60 <release>
80103439:	83 c4 10             	add    $0x10,%esp
}
8010343c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010343f:	5b                   	pop    %ebx
80103440:	5e                   	pop    %esi
80103441:	5f                   	pop    %edi
80103442:	5d                   	pop    %ebp
80103443:	c3                   	ret    
    panic("log.committing");
80103444:	83 ec 0c             	sub    $0xc,%esp
80103447:	68 a4 7f 10 80       	push   $0x80107fa4
8010344c:	e8 3f cf ff ff       	call   80100390 <panic>
80103451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103458:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010345f:	90                   	nop

80103460 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103460:	f3 0f 1e fb          	endbr32 
80103464:	55                   	push   %ebp
80103465:	89 e5                	mov    %esp,%ebp
80103467:	53                   	push   %ebx
80103468:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010346b:	8b 15 48 3c 11 80    	mov    0x80113c48,%edx
{
80103471:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103474:	83 fa 1d             	cmp    $0x1d,%edx
80103477:	0f 8f 91 00 00 00    	jg     8010350e <log_write+0xae>
8010347d:	a1 38 3c 11 80       	mov    0x80113c38,%eax
80103482:	83 e8 01             	sub    $0x1,%eax
80103485:	39 c2                	cmp    %eax,%edx
80103487:	0f 8d 81 00 00 00    	jge    8010350e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010348d:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
80103492:	85 c0                	test   %eax,%eax
80103494:	0f 8e 81 00 00 00    	jle    8010351b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010349a:	83 ec 0c             	sub    $0xc,%esp
8010349d:	68 00 3c 11 80       	push   $0x80113c00
801034a2:	e8 f9 18 00 00       	call   80104da0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801034a7:	8b 15 48 3c 11 80    	mov    0x80113c48,%edx
801034ad:	83 c4 10             	add    $0x10,%esp
801034b0:	85 d2                	test   %edx,%edx
801034b2:	7e 4e                	jle    80103502 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801034b4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801034b7:	31 c0                	xor    %eax,%eax
801034b9:	eb 0c                	jmp    801034c7 <log_write+0x67>
801034bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034bf:	90                   	nop
801034c0:	83 c0 01             	add    $0x1,%eax
801034c3:	39 c2                	cmp    %eax,%edx
801034c5:	74 29                	je     801034f0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801034c7:	39 0c 85 4c 3c 11 80 	cmp    %ecx,-0x7feec3b4(,%eax,4)
801034ce:	75 f0                	jne    801034c0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801034d0:	89 0c 85 4c 3c 11 80 	mov    %ecx,-0x7feec3b4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801034d7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801034da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801034dd:	c7 45 08 00 3c 11 80 	movl   $0x80113c00,0x8(%ebp)
}
801034e4:	c9                   	leave  
  release(&log.lock);
801034e5:	e9 76 19 00 00       	jmp    80104e60 <release>
801034ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801034f0:	89 0c 95 4c 3c 11 80 	mov    %ecx,-0x7feec3b4(,%edx,4)
    log.lh.n++;
801034f7:	83 c2 01             	add    $0x1,%edx
801034fa:	89 15 48 3c 11 80    	mov    %edx,0x80113c48
80103500:	eb d5                	jmp    801034d7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103502:	8b 43 08             	mov    0x8(%ebx),%eax
80103505:	a3 4c 3c 11 80       	mov    %eax,0x80113c4c
  if (i == log.lh.n)
8010350a:	75 cb                	jne    801034d7 <log_write+0x77>
8010350c:	eb e9                	jmp    801034f7 <log_write+0x97>
    panic("too big a transaction");
8010350e:	83 ec 0c             	sub    $0xc,%esp
80103511:	68 b3 7f 10 80       	push   $0x80107fb3
80103516:	e8 75 ce ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010351b:	83 ec 0c             	sub    $0xc,%esp
8010351e:	68 c9 7f 10 80       	push   $0x80107fc9
80103523:	e8 68 ce ff ff       	call   80100390 <panic>
80103528:	66 90                	xchg   %ax,%ax
8010352a:	66 90                	xchg   %ax,%ax
8010352c:	66 90                	xchg   %ax,%ax
8010352e:	66 90                	xchg   %ax,%ax

80103530 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	53                   	push   %ebx
80103534:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103537:	e8 84 09 00 00       	call   80103ec0 <cpuid>
8010353c:	89 c3                	mov    %eax,%ebx
8010353e:	e8 7d 09 00 00       	call   80103ec0 <cpuid>
80103543:	83 ec 04             	sub    $0x4,%esp
80103546:	53                   	push   %ebx
80103547:	50                   	push   %eax
80103548:	68 e4 7f 10 80       	push   $0x80107fe4
8010354d:	e8 5e d1 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103552:	e8 e9 2d 00 00       	call   80106340 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103557:	e8 f4 08 00 00       	call   80103e50 <mycpu>
8010355c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010355e:	b8 01 00 00 00       	mov    $0x1,%eax
80103563:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010356a:	e8 41 0c 00 00       	call   801041b0 <scheduler>
8010356f:	90                   	nop

80103570 <mpenter>:
{
80103570:	f3 0f 1e fb          	endbr32 
80103574:	55                   	push   %ebp
80103575:	89 e5                	mov    %esp,%ebp
80103577:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010357a:	e8 91 3e 00 00       	call   80107410 <switchkvm>
  seginit();
8010357f:	e8 fc 3d 00 00       	call   80107380 <seginit>
  lapicinit();
80103584:	e8 67 f7 ff ff       	call   80102cf0 <lapicinit>
  mpmain();
80103589:	e8 a2 ff ff ff       	call   80103530 <mpmain>
8010358e:	66 90                	xchg   %ax,%ax

80103590 <main>:
{
80103590:	f3 0f 1e fb          	endbr32 
80103594:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103598:	83 e4 f0             	and    $0xfffffff0,%esp
8010359b:	ff 71 fc             	pushl  -0x4(%ecx)
8010359e:	55                   	push   %ebp
8010359f:	89 e5                	mov    %esp,%ebp
801035a1:	53                   	push   %ebx
801035a2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801035a3:	83 ec 08             	sub    $0x8,%esp
801035a6:	68 00 00 40 80       	push   $0x80400000
801035ab:	68 e8 86 11 80       	push   $0x801186e8
801035b0:	e8 fb f4 ff ff       	call   80102ab0 <kinit1>
  kvmalloc();      // kernel page table
801035b5:	e8 36 43 00 00       	call   801078f0 <kvmalloc>
  mpinit();        // detect other processors
801035ba:	e8 81 01 00 00       	call   80103740 <mpinit>
  lapicinit();     // interrupt controller
801035bf:	e8 2c f7 ff ff       	call   80102cf0 <lapicinit>
  seginit();       // segment descriptors
801035c4:	e8 b7 3d 00 00       	call   80107380 <seginit>
  picinit();       // disable pic
801035c9:	e8 52 03 00 00       	call   80103920 <picinit>
  ioapicinit();    // another interrupt controller
801035ce:	e8 fd f2 ff ff       	call   801028d0 <ioapicinit>
  consoleinit();   // console hardware
801035d3:	e8 a8 d9 ff ff       	call   80100f80 <consoleinit>
  uartinit();      // serial port
801035d8:	e8 63 30 00 00       	call   80106640 <uartinit>
  pinit();         // process table
801035dd:	e8 4e 08 00 00       	call   80103e30 <pinit>
  tvinit();        // trap vectors
801035e2:	e8 d9 2c 00 00       	call   801062c0 <tvinit>
  binit();         // buffer cache
801035e7:	e8 54 ca ff ff       	call   80100040 <binit>
  fileinit();      // file table
801035ec:	e8 3f dd ff ff       	call   80101330 <fileinit>
  ideinit();       // disk 
801035f1:	e8 aa f0 ff ff       	call   801026a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801035f6:	83 c4 0c             	add    $0xc,%esp
801035f9:	68 8a 00 00 00       	push   $0x8a
801035fe:	68 8c b4 10 80       	push   $0x8010b48c
80103603:	68 00 70 00 80       	push   $0x80007000
80103608:	e8 43 19 00 00       	call   80104f50 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010360d:	83 c4 10             	add    $0x10,%esp
80103610:	69 05 80 42 11 80 b0 	imul   $0xb0,0x80114280,%eax
80103617:	00 00 00 
8010361a:	05 00 3d 11 80       	add    $0x80113d00,%eax
8010361f:	3d 00 3d 11 80       	cmp    $0x80113d00,%eax
80103624:	76 7a                	jbe    801036a0 <main+0x110>
80103626:	bb 00 3d 11 80       	mov    $0x80113d00,%ebx
8010362b:	eb 1c                	jmp    80103649 <main+0xb9>
8010362d:	8d 76 00             	lea    0x0(%esi),%esi
80103630:	69 05 80 42 11 80 b0 	imul   $0xb0,0x80114280,%eax
80103637:	00 00 00 
8010363a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103640:	05 00 3d 11 80       	add    $0x80113d00,%eax
80103645:	39 c3                	cmp    %eax,%ebx
80103647:	73 57                	jae    801036a0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103649:	e8 02 08 00 00       	call   80103e50 <mycpu>
8010364e:	39 c3                	cmp    %eax,%ebx
80103650:	74 de                	je     80103630 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103652:	e8 29 f5 ff ff       	call   80102b80 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103657:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010365a:	c7 05 f8 6f 00 80 70 	movl   $0x80103570,0x80006ff8
80103661:	35 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103664:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010366b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010366e:	05 00 10 00 00       	add    $0x1000,%eax
80103673:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103678:	0f b6 03             	movzbl (%ebx),%eax
8010367b:	68 00 70 00 00       	push   $0x7000
80103680:	50                   	push   %eax
80103681:	e8 ba f7 ff ff       	call   80102e40 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103686:	83 c4 10             	add    $0x10,%esp
80103689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103690:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103696:	85 c0                	test   %eax,%eax
80103698:	74 f6                	je     80103690 <main+0x100>
8010369a:	eb 94                	jmp    80103630 <main+0xa0>
8010369c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801036a0:	83 ec 08             	sub    $0x8,%esp
801036a3:	68 00 00 00 8e       	push   $0x8e000000
801036a8:	68 00 00 40 80       	push   $0x80400000
801036ad:	e8 6e f4 ff ff       	call   80102b20 <kinit2>
  userinit();      // first user process
801036b2:	e8 59 08 00 00       	call   80103f10 <userinit>
  mpmain();        // finish this processor's setup
801036b7:	e8 74 fe ff ff       	call   80103530 <mpmain>
801036bc:	66 90                	xchg   %ax,%ax
801036be:	66 90                	xchg   %ax,%ax

801036c0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	57                   	push   %edi
801036c4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801036c5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801036cb:	53                   	push   %ebx
  e = addr+len;
801036cc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801036cf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801036d2:	39 de                	cmp    %ebx,%esi
801036d4:	72 10                	jb     801036e6 <mpsearch1+0x26>
801036d6:	eb 50                	jmp    80103728 <mpsearch1+0x68>
801036d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036df:	90                   	nop
801036e0:	89 fe                	mov    %edi,%esi
801036e2:	39 fb                	cmp    %edi,%ebx
801036e4:	76 42                	jbe    80103728 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036e6:	83 ec 04             	sub    $0x4,%esp
801036e9:	8d 7e 10             	lea    0x10(%esi),%edi
801036ec:	6a 04                	push   $0x4
801036ee:	68 f8 7f 10 80       	push   $0x80107ff8
801036f3:	56                   	push   %esi
801036f4:	e8 07 18 00 00       	call   80104f00 <memcmp>
801036f9:	83 c4 10             	add    $0x10,%esp
801036fc:	85 c0                	test   %eax,%eax
801036fe:	75 e0                	jne    801036e0 <mpsearch1+0x20>
80103700:	89 f2                	mov    %esi,%edx
80103702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103708:	0f b6 0a             	movzbl (%edx),%ecx
8010370b:	83 c2 01             	add    $0x1,%edx
8010370e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103710:	39 fa                	cmp    %edi,%edx
80103712:	75 f4                	jne    80103708 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103714:	84 c0                	test   %al,%al
80103716:	75 c8                	jne    801036e0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103718:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010371b:	89 f0                	mov    %esi,%eax
8010371d:	5b                   	pop    %ebx
8010371e:	5e                   	pop    %esi
8010371f:	5f                   	pop    %edi
80103720:	5d                   	pop    %ebp
80103721:	c3                   	ret    
80103722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103728:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010372b:	31 f6                	xor    %esi,%esi
}
8010372d:	5b                   	pop    %ebx
8010372e:	89 f0                	mov    %esi,%eax
80103730:	5e                   	pop    %esi
80103731:	5f                   	pop    %edi
80103732:	5d                   	pop    %ebp
80103733:	c3                   	ret    
80103734:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010373b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010373f:	90                   	nop

80103740 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103740:	f3 0f 1e fb          	endbr32 
80103744:	55                   	push   %ebp
80103745:	89 e5                	mov    %esp,%ebp
80103747:	57                   	push   %edi
80103748:	56                   	push   %esi
80103749:	53                   	push   %ebx
8010374a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010374d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103754:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010375b:	c1 e0 08             	shl    $0x8,%eax
8010375e:	09 d0                	or     %edx,%eax
80103760:	c1 e0 04             	shl    $0x4,%eax
80103763:	75 1b                	jne    80103780 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103765:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010376c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103773:	c1 e0 08             	shl    $0x8,%eax
80103776:	09 d0                	or     %edx,%eax
80103778:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010377b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103780:	ba 00 04 00 00       	mov    $0x400,%edx
80103785:	e8 36 ff ff ff       	call   801036c0 <mpsearch1>
8010378a:	89 c6                	mov    %eax,%esi
8010378c:	85 c0                	test   %eax,%eax
8010378e:	0f 84 4c 01 00 00    	je     801038e0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103794:	8b 5e 04             	mov    0x4(%esi),%ebx
80103797:	85 db                	test   %ebx,%ebx
80103799:	0f 84 61 01 00 00    	je     80103900 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010379f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801037a2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801037a8:	6a 04                	push   $0x4
801037aa:	68 fd 7f 10 80       	push   $0x80107ffd
801037af:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801037b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801037b3:	e8 48 17 00 00       	call   80104f00 <memcmp>
801037b8:	83 c4 10             	add    $0x10,%esp
801037bb:	85 c0                	test   %eax,%eax
801037bd:	0f 85 3d 01 00 00    	jne    80103900 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801037c3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801037ca:	3c 01                	cmp    $0x1,%al
801037cc:	74 08                	je     801037d6 <mpinit+0x96>
801037ce:	3c 04                	cmp    $0x4,%al
801037d0:	0f 85 2a 01 00 00    	jne    80103900 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
801037d6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801037dd:	66 85 d2             	test   %dx,%dx
801037e0:	74 26                	je     80103808 <mpinit+0xc8>
801037e2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801037e5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801037e7:	31 d2                	xor    %edx,%edx
801037e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801037f0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801037f7:	83 c0 01             	add    $0x1,%eax
801037fa:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801037fc:	39 f8                	cmp    %edi,%eax
801037fe:	75 f0                	jne    801037f0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103800:	84 d2                	test   %dl,%dl
80103802:	0f 85 f8 00 00 00    	jne    80103900 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103808:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010380e:	a3 fc 3b 11 80       	mov    %eax,0x80113bfc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103813:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103819:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103820:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103825:	03 55 e4             	add    -0x1c(%ebp),%edx
80103828:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010382b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010382f:	90                   	nop
80103830:	39 c2                	cmp    %eax,%edx
80103832:	76 15                	jbe    80103849 <mpinit+0x109>
    switch(*p){
80103834:	0f b6 08             	movzbl (%eax),%ecx
80103837:	80 f9 02             	cmp    $0x2,%cl
8010383a:	74 5c                	je     80103898 <mpinit+0x158>
8010383c:	77 42                	ja     80103880 <mpinit+0x140>
8010383e:	84 c9                	test   %cl,%cl
80103840:	74 6e                	je     801038b0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103842:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103845:	39 c2                	cmp    %eax,%edx
80103847:	77 eb                	ja     80103834 <mpinit+0xf4>
80103849:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010384c:	85 db                	test   %ebx,%ebx
8010384e:	0f 84 b9 00 00 00    	je     8010390d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103854:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103858:	74 15                	je     8010386f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010385a:	b8 70 00 00 00       	mov    $0x70,%eax
8010385f:	ba 22 00 00 00       	mov    $0x22,%edx
80103864:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103865:	ba 23 00 00 00       	mov    $0x23,%edx
8010386a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010386b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010386e:	ee                   	out    %al,(%dx)
  }
}
8010386f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103872:	5b                   	pop    %ebx
80103873:	5e                   	pop    %esi
80103874:	5f                   	pop    %edi
80103875:	5d                   	pop    %ebp
80103876:	c3                   	ret    
80103877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010387e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103880:	83 e9 03             	sub    $0x3,%ecx
80103883:	80 f9 01             	cmp    $0x1,%cl
80103886:	76 ba                	jbe    80103842 <mpinit+0x102>
80103888:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010388f:	eb 9f                	jmp    80103830 <mpinit+0xf0>
80103891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103898:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010389c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010389f:	88 0d e0 3c 11 80    	mov    %cl,0x80113ce0
      continue;
801038a5:	eb 89                	jmp    80103830 <mpinit+0xf0>
801038a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ae:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801038b0:	8b 0d 80 42 11 80    	mov    0x80114280,%ecx
801038b6:	83 f9 07             	cmp    $0x7,%ecx
801038b9:	7f 19                	jg     801038d4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801038bb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801038c1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801038c5:	83 c1 01             	add    $0x1,%ecx
801038c8:	89 0d 80 42 11 80    	mov    %ecx,0x80114280
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801038ce:	88 9f 00 3d 11 80    	mov    %bl,-0x7feec300(%edi)
      p += sizeof(struct mpproc);
801038d4:	83 c0 14             	add    $0x14,%eax
      continue;
801038d7:	e9 54 ff ff ff       	jmp    80103830 <mpinit+0xf0>
801038dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801038e0:	ba 00 00 01 00       	mov    $0x10000,%edx
801038e5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801038ea:	e8 d1 fd ff ff       	call   801036c0 <mpsearch1>
801038ef:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801038f1:	85 c0                	test   %eax,%eax
801038f3:	0f 85 9b fe ff ff    	jne    80103794 <mpinit+0x54>
801038f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103900:	83 ec 0c             	sub    $0xc,%esp
80103903:	68 02 80 10 80       	push   $0x80108002
80103908:	e8 83 ca ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010390d:	83 ec 0c             	sub    $0xc,%esp
80103910:	68 1c 80 10 80       	push   $0x8010801c
80103915:	e8 76 ca ff ff       	call   80100390 <panic>
8010391a:	66 90                	xchg   %ax,%ax
8010391c:	66 90                	xchg   %ax,%ax
8010391e:	66 90                	xchg   %ax,%ax

80103920 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103920:	f3 0f 1e fb          	endbr32 
80103924:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103929:	ba 21 00 00 00       	mov    $0x21,%edx
8010392e:	ee                   	out    %al,(%dx)
8010392f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103934:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103935:	c3                   	ret    
80103936:	66 90                	xchg   %ax,%ax
80103938:	66 90                	xchg   %ax,%ax
8010393a:	66 90                	xchg   %ax,%ax
8010393c:	66 90                	xchg   %ax,%ax
8010393e:	66 90                	xchg   %ax,%ax

80103940 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103940:	f3 0f 1e fb          	endbr32 
80103944:	55                   	push   %ebp
80103945:	89 e5                	mov    %esp,%ebp
80103947:	57                   	push   %edi
80103948:	56                   	push   %esi
80103949:	53                   	push   %ebx
8010394a:	83 ec 0c             	sub    $0xc,%esp
8010394d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103950:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103953:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103959:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010395f:	e8 ec d9 ff ff       	call   80101350 <filealloc>
80103964:	89 03                	mov    %eax,(%ebx)
80103966:	85 c0                	test   %eax,%eax
80103968:	0f 84 ac 00 00 00    	je     80103a1a <pipealloc+0xda>
8010396e:	e8 dd d9 ff ff       	call   80101350 <filealloc>
80103973:	89 06                	mov    %eax,(%esi)
80103975:	85 c0                	test   %eax,%eax
80103977:	0f 84 8b 00 00 00    	je     80103a08 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010397d:	e8 fe f1 ff ff       	call   80102b80 <kalloc>
80103982:	89 c7                	mov    %eax,%edi
80103984:	85 c0                	test   %eax,%eax
80103986:	0f 84 b4 00 00 00    	je     80103a40 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010398c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103993:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103996:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103999:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801039a0:	00 00 00 
  p->nwrite = 0;
801039a3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801039aa:	00 00 00 
  p->nread = 0;
801039ad:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801039b4:	00 00 00 
  initlock(&p->lock, "pipe");
801039b7:	68 3b 80 10 80       	push   $0x8010803b
801039bc:	50                   	push   %eax
801039bd:	e8 5e 12 00 00       	call   80104c20 <initlock>
  (*f0)->type = FD_PIPE;
801039c2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801039c4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801039c7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801039cd:	8b 03                	mov    (%ebx),%eax
801039cf:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801039d3:	8b 03                	mov    (%ebx),%eax
801039d5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801039d9:	8b 03                	mov    (%ebx),%eax
801039db:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801039de:	8b 06                	mov    (%esi),%eax
801039e0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801039e6:	8b 06                	mov    (%esi),%eax
801039e8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801039ec:	8b 06                	mov    (%esi),%eax
801039ee:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801039f2:	8b 06                	mov    (%esi),%eax
801039f4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801039f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801039fa:	31 c0                	xor    %eax,%eax
}
801039fc:	5b                   	pop    %ebx
801039fd:	5e                   	pop    %esi
801039fe:	5f                   	pop    %edi
801039ff:	5d                   	pop    %ebp
80103a00:	c3                   	ret    
80103a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103a08:	8b 03                	mov    (%ebx),%eax
80103a0a:	85 c0                	test   %eax,%eax
80103a0c:	74 1e                	je     80103a2c <pipealloc+0xec>
    fileclose(*f0);
80103a0e:	83 ec 0c             	sub    $0xc,%esp
80103a11:	50                   	push   %eax
80103a12:	e8 f9 d9 ff ff       	call   80101410 <fileclose>
80103a17:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103a1a:	8b 06                	mov    (%esi),%eax
80103a1c:	85 c0                	test   %eax,%eax
80103a1e:	74 0c                	je     80103a2c <pipealloc+0xec>
    fileclose(*f1);
80103a20:	83 ec 0c             	sub    $0xc,%esp
80103a23:	50                   	push   %eax
80103a24:	e8 e7 d9 ff ff       	call   80101410 <fileclose>
80103a29:	83 c4 10             	add    $0x10,%esp
}
80103a2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103a2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103a34:	5b                   	pop    %ebx
80103a35:	5e                   	pop    %esi
80103a36:	5f                   	pop    %edi
80103a37:	5d                   	pop    %ebp
80103a38:	c3                   	ret    
80103a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103a40:	8b 03                	mov    (%ebx),%eax
80103a42:	85 c0                	test   %eax,%eax
80103a44:	75 c8                	jne    80103a0e <pipealloc+0xce>
80103a46:	eb d2                	jmp    80103a1a <pipealloc+0xda>
80103a48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a4f:	90                   	nop

80103a50 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103a50:	f3 0f 1e fb          	endbr32 
80103a54:	55                   	push   %ebp
80103a55:	89 e5                	mov    %esp,%ebp
80103a57:	56                   	push   %esi
80103a58:	53                   	push   %ebx
80103a59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103a5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103a5f:	83 ec 0c             	sub    $0xc,%esp
80103a62:	53                   	push   %ebx
80103a63:	e8 38 13 00 00       	call   80104da0 <acquire>
  if(writable){
80103a68:	83 c4 10             	add    $0x10,%esp
80103a6b:	85 f6                	test   %esi,%esi
80103a6d:	74 41                	je     80103ab0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103a6f:	83 ec 0c             	sub    $0xc,%esp
80103a72:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103a78:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103a7f:	00 00 00 
    wakeup(&p->nread);
80103a82:	50                   	push   %eax
80103a83:	e8 d8 0b 00 00       	call   80104660 <wakeup>
80103a88:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103a8b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103a91:	85 d2                	test   %edx,%edx
80103a93:	75 0a                	jne    80103a9f <pipeclose+0x4f>
80103a95:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103a9b:	85 c0                	test   %eax,%eax
80103a9d:	74 31                	je     80103ad0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103a9f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103aa2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103aa5:	5b                   	pop    %ebx
80103aa6:	5e                   	pop    %esi
80103aa7:	5d                   	pop    %ebp
    release(&p->lock);
80103aa8:	e9 b3 13 00 00       	jmp    80104e60 <release>
80103aad:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103ab0:	83 ec 0c             	sub    $0xc,%esp
80103ab3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103ab9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103ac0:	00 00 00 
    wakeup(&p->nwrite);
80103ac3:	50                   	push   %eax
80103ac4:	e8 97 0b 00 00       	call   80104660 <wakeup>
80103ac9:	83 c4 10             	add    $0x10,%esp
80103acc:	eb bd                	jmp    80103a8b <pipeclose+0x3b>
80103ace:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103ad0:	83 ec 0c             	sub    $0xc,%esp
80103ad3:	53                   	push   %ebx
80103ad4:	e8 87 13 00 00       	call   80104e60 <release>
    kfree((char*)p);
80103ad9:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103adc:	83 c4 10             	add    $0x10,%esp
}
80103adf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ae2:	5b                   	pop    %ebx
80103ae3:	5e                   	pop    %esi
80103ae4:	5d                   	pop    %ebp
    kfree((char*)p);
80103ae5:	e9 d6 ee ff ff       	jmp    801029c0 <kfree>
80103aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103af0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103af0:	f3 0f 1e fb          	endbr32 
80103af4:	55                   	push   %ebp
80103af5:	89 e5                	mov    %esp,%ebp
80103af7:	57                   	push   %edi
80103af8:	56                   	push   %esi
80103af9:	53                   	push   %ebx
80103afa:	83 ec 28             	sub    $0x28,%esp
80103afd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103b00:	53                   	push   %ebx
80103b01:	e8 9a 12 00 00       	call   80104da0 <acquire>
  for(i = 0; i < n; i++){
80103b06:	8b 45 10             	mov    0x10(%ebp),%eax
80103b09:	83 c4 10             	add    $0x10,%esp
80103b0c:	85 c0                	test   %eax,%eax
80103b0e:	0f 8e bc 00 00 00    	jle    80103bd0 <pipewrite+0xe0>
80103b14:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b17:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103b1d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103b23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b26:	03 45 10             	add    0x10(%ebp),%eax
80103b29:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b2c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103b32:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b38:	89 ca                	mov    %ecx,%edx
80103b3a:	05 00 02 00 00       	add    $0x200,%eax
80103b3f:	39 c1                	cmp    %eax,%ecx
80103b41:	74 3b                	je     80103b7e <pipewrite+0x8e>
80103b43:	eb 63                	jmp    80103ba8 <pipewrite+0xb8>
80103b45:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103b48:	e8 93 03 00 00       	call   80103ee0 <myproc>
80103b4d:	8b 48 24             	mov    0x24(%eax),%ecx
80103b50:	85 c9                	test   %ecx,%ecx
80103b52:	75 34                	jne    80103b88 <pipewrite+0x98>
      wakeup(&p->nread);
80103b54:	83 ec 0c             	sub    $0xc,%esp
80103b57:	57                   	push   %edi
80103b58:	e8 03 0b 00 00       	call   80104660 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103b5d:	58                   	pop    %eax
80103b5e:	5a                   	pop    %edx
80103b5f:	53                   	push   %ebx
80103b60:	56                   	push   %esi
80103b61:	e8 3a 09 00 00       	call   801044a0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b66:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103b6c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103b72:	83 c4 10             	add    $0x10,%esp
80103b75:	05 00 02 00 00       	add    $0x200,%eax
80103b7a:	39 c2                	cmp    %eax,%edx
80103b7c:	75 2a                	jne    80103ba8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103b7e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103b84:	85 c0                	test   %eax,%eax
80103b86:	75 c0                	jne    80103b48 <pipewrite+0x58>
        release(&p->lock);
80103b88:	83 ec 0c             	sub    $0xc,%esp
80103b8b:	53                   	push   %ebx
80103b8c:	e8 cf 12 00 00       	call   80104e60 <release>
        return -1;
80103b91:	83 c4 10             	add    $0x10,%esp
80103b94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103b99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b9c:	5b                   	pop    %ebx
80103b9d:	5e                   	pop    %esi
80103b9e:	5f                   	pop    %edi
80103b9f:	5d                   	pop    %ebp
80103ba0:	c3                   	ret    
80103ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103ba8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103bab:	8d 4a 01             	lea    0x1(%edx),%ecx
80103bae:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103bb4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103bba:	0f b6 06             	movzbl (%esi),%eax
80103bbd:	83 c6 01             	add    $0x1,%esi
80103bc0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103bc3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103bc7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103bca:	0f 85 5c ff ff ff    	jne    80103b2c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103bd0:	83 ec 0c             	sub    $0xc,%esp
80103bd3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103bd9:	50                   	push   %eax
80103bda:	e8 81 0a 00 00       	call   80104660 <wakeup>
  release(&p->lock);
80103bdf:	89 1c 24             	mov    %ebx,(%esp)
80103be2:	e8 79 12 00 00       	call   80104e60 <release>
  return n;
80103be7:	8b 45 10             	mov    0x10(%ebp),%eax
80103bea:	83 c4 10             	add    $0x10,%esp
80103bed:	eb aa                	jmp    80103b99 <pipewrite+0xa9>
80103bef:	90                   	nop

80103bf0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103bf0:	f3 0f 1e fb          	endbr32 
80103bf4:	55                   	push   %ebp
80103bf5:	89 e5                	mov    %esp,%ebp
80103bf7:	57                   	push   %edi
80103bf8:	56                   	push   %esi
80103bf9:	53                   	push   %ebx
80103bfa:	83 ec 18             	sub    $0x18,%esp
80103bfd:	8b 75 08             	mov    0x8(%ebp),%esi
80103c00:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103c03:	56                   	push   %esi
80103c04:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103c0a:	e8 91 11 00 00       	call   80104da0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103c0f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103c15:	83 c4 10             	add    $0x10,%esp
80103c18:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103c1e:	74 33                	je     80103c53 <piperead+0x63>
80103c20:	eb 3b                	jmp    80103c5d <piperead+0x6d>
80103c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103c28:	e8 b3 02 00 00       	call   80103ee0 <myproc>
80103c2d:	8b 48 24             	mov    0x24(%eax),%ecx
80103c30:	85 c9                	test   %ecx,%ecx
80103c32:	0f 85 88 00 00 00    	jne    80103cc0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103c38:	83 ec 08             	sub    $0x8,%esp
80103c3b:	56                   	push   %esi
80103c3c:	53                   	push   %ebx
80103c3d:	e8 5e 08 00 00       	call   801044a0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103c42:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103c48:	83 c4 10             	add    $0x10,%esp
80103c4b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103c51:	75 0a                	jne    80103c5d <piperead+0x6d>
80103c53:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103c59:	85 c0                	test   %eax,%eax
80103c5b:	75 cb                	jne    80103c28 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103c5d:	8b 55 10             	mov    0x10(%ebp),%edx
80103c60:	31 db                	xor    %ebx,%ebx
80103c62:	85 d2                	test   %edx,%edx
80103c64:	7f 28                	jg     80103c8e <piperead+0x9e>
80103c66:	eb 34                	jmp    80103c9c <piperead+0xac>
80103c68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c6f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103c70:	8d 48 01             	lea    0x1(%eax),%ecx
80103c73:	25 ff 01 00 00       	and    $0x1ff,%eax
80103c78:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103c7e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103c83:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103c86:	83 c3 01             	add    $0x1,%ebx
80103c89:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103c8c:	74 0e                	je     80103c9c <piperead+0xac>
    if(p->nread == p->nwrite)
80103c8e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103c94:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103c9a:	75 d4                	jne    80103c70 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103c9c:	83 ec 0c             	sub    $0xc,%esp
80103c9f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103ca5:	50                   	push   %eax
80103ca6:	e8 b5 09 00 00       	call   80104660 <wakeup>
  release(&p->lock);
80103cab:	89 34 24             	mov    %esi,(%esp)
80103cae:	e8 ad 11 00 00       	call   80104e60 <release>
  return i;
80103cb3:	83 c4 10             	add    $0x10,%esp
}
80103cb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cb9:	89 d8                	mov    %ebx,%eax
80103cbb:	5b                   	pop    %ebx
80103cbc:	5e                   	pop    %esi
80103cbd:	5f                   	pop    %edi
80103cbe:	5d                   	pop    %ebp
80103cbf:	c3                   	ret    
      release(&p->lock);
80103cc0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103cc3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103cc8:	56                   	push   %esi
80103cc9:	e8 92 11 00 00       	call   80104e60 <release>
      return -1;
80103cce:	83 c4 10             	add    $0x10,%esp
}
80103cd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cd4:	89 d8                	mov    %ebx,%eax
80103cd6:	5b                   	pop    %ebx
80103cd7:	5e                   	pop    %esi
80103cd8:	5f                   	pop    %edi
80103cd9:	5d                   	pop    %ebp
80103cda:	c3                   	ret    
80103cdb:	66 90                	xchg   %ax,%ax
80103cdd:	66 90                	xchg   %ax,%ax
80103cdf:	90                   	nop

80103ce0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ce4:	bb 94 46 11 80       	mov    $0x80114694,%ebx
{
80103ce9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103cec:	68 60 46 11 80       	push   $0x80114660
80103cf1:	e8 aa 10 00 00       	call   80104da0 <acquire>
80103cf6:	83 c4 10             	add    $0x10,%esp
80103cf9:	eb 17                	jmp    80103d12 <allocproc+0x32>
80103cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cff:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d00:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
80103d06:	81 fb 94 7e 11 80    	cmp    $0x80117e94,%ebx
80103d0c:	0f 84 96 00 00 00    	je     80103da8 <allocproc+0xc8>
    if(p->state == UNUSED)
80103d12:	8b 43 0c             	mov    0xc(%ebx),%eax
80103d15:	85 c0                	test   %eax,%eax
80103d17:	75 e7                	jne    80103d00 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103d19:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103d1e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103d21:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103d28:	89 43 10             	mov    %eax,0x10(%ebx)
80103d2b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103d2e:	68 60 46 11 80       	push   $0x80114660
  p->pid = nextpid++;
80103d33:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103d39:	e8 22 11 00 00       	call   80104e60 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103d3e:	e8 3d ee ff ff       	call   80102b80 <kalloc>
80103d43:	83 c4 10             	add    $0x10,%esp
80103d46:	89 43 08             	mov    %eax,0x8(%ebx)
80103d49:	85 c0                	test   %eax,%eax
80103d4b:	74 74                	je     80103dc1 <allocproc+0xe1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103d4d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103d53:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103d56:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103d5b:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103d5e:	c7 40 14 ab 62 10 80 	movl   $0x801062ab,0x14(%eax)
  p->context = (struct context*)sp;
80103d65:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103d68:	6a 14                	push   $0x14
80103d6a:	6a 00                	push   $0x0
80103d6c:	50                   	push   %eax
80103d6d:	e8 3e 11 00 00       	call   80104eb0 <memset>
  p->context->eip = (uint)forkret;
80103d72:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103d75:	8d 93 e0 00 00 00    	lea    0xe0(%ebx),%edx
80103d7b:	83 c4 10             	add    $0x10,%esp
80103d7e:	c7 40 10 e0 3d 10 80 	movl   $0x80103de0,0x10(%eax)


  for(int i=0; i<25; i++)
80103d85:	8d 43 7c             	lea    0x7c(%ebx),%eax
80103d88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d8f:	90                   	nop
    p->sys_call_count[i] = 0;
80103d90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i=0; i<25; i++)
80103d96:	83 c0 04             	add    $0x4,%eax
80103d99:	39 c2                	cmp    %eax,%edx
80103d9b:	75 f3                	jne    80103d90 <allocproc+0xb0>

  return p;
}
80103d9d:	89 d8                	mov    %ebx,%eax
80103d9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103da2:	c9                   	leave  
80103da3:	c3                   	ret    
80103da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103da8:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103dab:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103dad:	68 60 46 11 80       	push   $0x80114660
80103db2:	e8 a9 10 00 00       	call   80104e60 <release>
}
80103db7:	89 d8                	mov    %ebx,%eax
  return 0;
80103db9:	83 c4 10             	add    $0x10,%esp
}
80103dbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dbf:	c9                   	leave  
80103dc0:	c3                   	ret    
    p->state = UNUSED;
80103dc1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103dc8:	31 db                	xor    %ebx,%ebx
}
80103dca:	89 d8                	mov    %ebx,%eax
80103dcc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dcf:	c9                   	leave  
80103dd0:	c3                   	ret    
80103dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ddf:	90                   	nop

80103de0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103de0:	f3 0f 1e fb          	endbr32 
80103de4:	55                   	push   %ebp
80103de5:	89 e5                	mov    %esp,%ebp
80103de7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103dea:	68 60 46 11 80       	push   $0x80114660
80103def:	e8 6c 10 00 00       	call   80104e60 <release>

  if (first) {
80103df4:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103df9:	83 c4 10             	add    $0x10,%esp
80103dfc:	85 c0                	test   %eax,%eax
80103dfe:	75 08                	jne    80103e08 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103e00:	c9                   	leave  
80103e01:	c3                   	ret    
80103e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103e08:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103e0f:	00 00 00 
    iinit(ROOTDEV);
80103e12:	83 ec 0c             	sub    $0xc,%esp
80103e15:	6a 01                	push   $0x1
80103e17:	e8 74 dc ff ff       	call   80101a90 <iinit>
    initlog(ROOTDEV);
80103e1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103e23:	e8 b8 f3 ff ff       	call   801031e0 <initlog>
}
80103e28:	83 c4 10             	add    $0x10,%esp
80103e2b:	c9                   	leave  
80103e2c:	c3                   	ret    
80103e2d:	8d 76 00             	lea    0x0(%esi),%esi

80103e30 <pinit>:
{
80103e30:	f3 0f 1e fb          	endbr32 
80103e34:	55                   	push   %ebp
80103e35:	89 e5                	mov    %esp,%ebp
80103e37:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103e3a:	68 40 80 10 80       	push   $0x80108040
80103e3f:	68 60 46 11 80       	push   $0x80114660
80103e44:	e8 d7 0d 00 00       	call   80104c20 <initlock>
}
80103e49:	83 c4 10             	add    $0x10,%esp
80103e4c:	c9                   	leave  
80103e4d:	c3                   	ret    
80103e4e:	66 90                	xchg   %ax,%ax

80103e50 <mycpu>:
{
80103e50:	f3 0f 1e fb          	endbr32 
80103e54:	55                   	push   %ebp
80103e55:	89 e5                	mov    %esp,%ebp
80103e57:	56                   	push   %esi
80103e58:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e59:	9c                   	pushf  
80103e5a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e5b:	f6 c4 02             	test   $0x2,%ah
80103e5e:	75 4a                	jne    80103eaa <mycpu+0x5a>
  apicid = lapicid();
80103e60:	e8 8b ef ff ff       	call   80102df0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103e65:	8b 35 80 42 11 80    	mov    0x80114280,%esi
  apicid = lapicid();
80103e6b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103e6d:	85 f6                	test   %esi,%esi
80103e6f:	7e 2c                	jle    80103e9d <mycpu+0x4d>
80103e71:	31 d2                	xor    %edx,%edx
80103e73:	eb 0a                	jmp    80103e7f <mycpu+0x2f>
80103e75:	8d 76 00             	lea    0x0(%esi),%esi
80103e78:	83 c2 01             	add    $0x1,%edx
80103e7b:	39 f2                	cmp    %esi,%edx
80103e7d:	74 1e                	je     80103e9d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103e7f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103e85:	0f b6 81 00 3d 11 80 	movzbl -0x7feec300(%ecx),%eax
80103e8c:	39 d8                	cmp    %ebx,%eax
80103e8e:	75 e8                	jne    80103e78 <mycpu+0x28>
}
80103e90:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103e93:	8d 81 00 3d 11 80    	lea    -0x7feec300(%ecx),%eax
}
80103e99:	5b                   	pop    %ebx
80103e9a:	5e                   	pop    %esi
80103e9b:	5d                   	pop    %ebp
80103e9c:	c3                   	ret    
  panic("unknown apicid\n");
80103e9d:	83 ec 0c             	sub    $0xc,%esp
80103ea0:	68 47 80 10 80       	push   $0x80108047
80103ea5:	e8 e6 c4 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103eaa:	83 ec 0c             	sub    $0xc,%esp
80103ead:	68 3c 81 10 80       	push   $0x8010813c
80103eb2:	e8 d9 c4 ff ff       	call   80100390 <panic>
80103eb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ebe:	66 90                	xchg   %ax,%ax

80103ec0 <cpuid>:
cpuid() {
80103ec0:	f3 0f 1e fb          	endbr32 
80103ec4:	55                   	push   %ebp
80103ec5:	89 e5                	mov    %esp,%ebp
80103ec7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103eca:	e8 81 ff ff ff       	call   80103e50 <mycpu>
}
80103ecf:	c9                   	leave  
  return mycpu()-cpus;
80103ed0:	2d 00 3d 11 80       	sub    $0x80113d00,%eax
80103ed5:	c1 f8 04             	sar    $0x4,%eax
80103ed8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103ede:	c3                   	ret    
80103edf:	90                   	nop

80103ee0 <myproc>:
myproc(void) {
80103ee0:	f3 0f 1e fb          	endbr32 
80103ee4:	55                   	push   %ebp
80103ee5:	89 e5                	mov    %esp,%ebp
80103ee7:	53                   	push   %ebx
80103ee8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103eeb:	e8 b0 0d 00 00       	call   80104ca0 <pushcli>
  c = mycpu();
80103ef0:	e8 5b ff ff ff       	call   80103e50 <mycpu>
  p = c->proc;
80103ef5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103efb:	e8 f0 0d 00 00       	call   80104cf0 <popcli>
}
80103f00:	83 c4 04             	add    $0x4,%esp
80103f03:	89 d8                	mov    %ebx,%eax
80103f05:	5b                   	pop    %ebx
80103f06:	5d                   	pop    %ebp
80103f07:	c3                   	ret    
80103f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f0f:	90                   	nop

80103f10 <userinit>:
{
80103f10:	f3 0f 1e fb          	endbr32 
80103f14:	55                   	push   %ebp
80103f15:	89 e5                	mov    %esp,%ebp
80103f17:	53                   	push   %ebx
80103f18:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103f1b:	e8 c0 fd ff ff       	call   80103ce0 <allocproc>
80103f20:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103f22:	a3 08 b6 10 80       	mov    %eax,0x8010b608
  if((p->pgdir = setupkvm()) == 0)
80103f27:	e8 44 39 00 00       	call   80107870 <setupkvm>
80103f2c:	89 43 04             	mov    %eax,0x4(%ebx)
80103f2f:	85 c0                	test   %eax,%eax
80103f31:	0f 84 bd 00 00 00    	je     80103ff4 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103f37:	83 ec 04             	sub    $0x4,%esp
80103f3a:	68 2c 00 00 00       	push   $0x2c
80103f3f:	68 60 b4 10 80       	push   $0x8010b460
80103f44:	50                   	push   %eax
80103f45:	e8 f6 35 00 00       	call   80107540 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103f4a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103f4d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103f53:	6a 4c                	push   $0x4c
80103f55:	6a 00                	push   $0x0
80103f57:	ff 73 18             	pushl  0x18(%ebx)
80103f5a:	e8 51 0f 00 00       	call   80104eb0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f5f:	8b 43 18             	mov    0x18(%ebx),%eax
80103f62:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103f67:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f6a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f6f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f73:	8b 43 18             	mov    0x18(%ebx),%eax
80103f76:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103f7a:	8b 43 18             	mov    0x18(%ebx),%eax
80103f7d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f81:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103f85:	8b 43 18             	mov    0x18(%ebx),%eax
80103f88:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f8c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103f90:	8b 43 18             	mov    0x18(%ebx),%eax
80103f93:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103f9a:	8b 43 18             	mov    0x18(%ebx),%eax
80103f9d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103fa4:	8b 43 18             	mov    0x18(%ebx),%eax
80103fa7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103fae:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103fb1:	6a 10                	push   $0x10
80103fb3:	68 70 80 10 80       	push   $0x80108070
80103fb8:	50                   	push   %eax
80103fb9:	e8 b2 10 00 00       	call   80105070 <safestrcpy>
  p->cwd = namei("/");
80103fbe:	c7 04 24 79 80 10 80 	movl   $0x80108079,(%esp)
80103fc5:	e8 b6 e5 ff ff       	call   80102580 <namei>
80103fca:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103fcd:	c7 04 24 60 46 11 80 	movl   $0x80114660,(%esp)
80103fd4:	e8 c7 0d 00 00       	call   80104da0 <acquire>
  p->state = RUNNABLE;
80103fd9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103fe0:	c7 04 24 60 46 11 80 	movl   $0x80114660,(%esp)
80103fe7:	e8 74 0e 00 00       	call   80104e60 <release>
}
80103fec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fef:	83 c4 10             	add    $0x10,%esp
80103ff2:	c9                   	leave  
80103ff3:	c3                   	ret    
    panic("userinit: out of memory?");
80103ff4:	83 ec 0c             	sub    $0xc,%esp
80103ff7:	68 57 80 10 80       	push   $0x80108057
80103ffc:	e8 8f c3 ff ff       	call   80100390 <panic>
80104001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104008:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010400f:	90                   	nop

80104010 <growproc>:
{
80104010:	f3 0f 1e fb          	endbr32 
80104014:	55                   	push   %ebp
80104015:	89 e5                	mov    %esp,%ebp
80104017:	56                   	push   %esi
80104018:	53                   	push   %ebx
80104019:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010401c:	e8 7f 0c 00 00       	call   80104ca0 <pushcli>
  c = mycpu();
80104021:	e8 2a fe ff ff       	call   80103e50 <mycpu>
  p = c->proc;
80104026:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010402c:	e8 bf 0c 00 00       	call   80104cf0 <popcli>
  sz = curproc->sz;
80104031:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104033:	85 f6                	test   %esi,%esi
80104035:	7f 19                	jg     80104050 <growproc+0x40>
  } else if(n < 0){
80104037:	75 37                	jne    80104070 <growproc+0x60>
  switchuvm(curproc);
80104039:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010403c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010403e:	53                   	push   %ebx
8010403f:	e8 ec 33 00 00       	call   80107430 <switchuvm>
  return 0;
80104044:	83 c4 10             	add    $0x10,%esp
80104047:	31 c0                	xor    %eax,%eax
}
80104049:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010404c:	5b                   	pop    %ebx
8010404d:	5e                   	pop    %esi
8010404e:	5d                   	pop    %ebp
8010404f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104050:	83 ec 04             	sub    $0x4,%esp
80104053:	01 c6                	add    %eax,%esi
80104055:	56                   	push   %esi
80104056:	50                   	push   %eax
80104057:	ff 73 04             	pushl  0x4(%ebx)
8010405a:	e8 31 36 00 00       	call   80107690 <allocuvm>
8010405f:	83 c4 10             	add    $0x10,%esp
80104062:	85 c0                	test   %eax,%eax
80104064:	75 d3                	jne    80104039 <growproc+0x29>
      return -1;
80104066:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010406b:	eb dc                	jmp    80104049 <growproc+0x39>
8010406d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104070:	83 ec 04             	sub    $0x4,%esp
80104073:	01 c6                	add    %eax,%esi
80104075:	56                   	push   %esi
80104076:	50                   	push   %eax
80104077:	ff 73 04             	pushl  0x4(%ebx)
8010407a:	e8 41 37 00 00       	call   801077c0 <deallocuvm>
8010407f:	83 c4 10             	add    $0x10,%esp
80104082:	85 c0                	test   %eax,%eax
80104084:	75 b3                	jne    80104039 <growproc+0x29>
80104086:	eb de                	jmp    80104066 <growproc+0x56>
80104088:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010408f:	90                   	nop

80104090 <fork>:
{
80104090:	f3 0f 1e fb          	endbr32 
80104094:	55                   	push   %ebp
80104095:	89 e5                	mov    %esp,%ebp
80104097:	57                   	push   %edi
80104098:	56                   	push   %esi
80104099:	53                   	push   %ebx
8010409a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
8010409d:	e8 fe 0b 00 00       	call   80104ca0 <pushcli>
  c = mycpu();
801040a2:	e8 a9 fd ff ff       	call   80103e50 <mycpu>
  p = c->proc;
801040a7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040ad:	e8 3e 0c 00 00       	call   80104cf0 <popcli>
  if((np = allocproc()) == 0){
801040b2:	e8 29 fc ff ff       	call   80103ce0 <allocproc>
801040b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801040ba:	85 c0                	test   %eax,%eax
801040bc:	0f 84 bb 00 00 00    	je     8010417d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801040c2:	83 ec 08             	sub    $0x8,%esp
801040c5:	ff 33                	pushl  (%ebx)
801040c7:	89 c7                	mov    %eax,%edi
801040c9:	ff 73 04             	pushl  0x4(%ebx)
801040cc:	e8 6f 38 00 00       	call   80107940 <copyuvm>
801040d1:	83 c4 10             	add    $0x10,%esp
801040d4:	89 47 04             	mov    %eax,0x4(%edi)
801040d7:	85 c0                	test   %eax,%eax
801040d9:	0f 84 a5 00 00 00    	je     80104184 <fork+0xf4>
  np->sz = curproc->sz;
801040df:	8b 03                	mov    (%ebx),%eax
801040e1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801040e4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801040e6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
801040e9:	89 c8                	mov    %ecx,%eax
801040eb:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801040ee:	b9 13 00 00 00       	mov    $0x13,%ecx
801040f3:	8b 73 18             	mov    0x18(%ebx),%esi
801040f6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801040f8:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801040fa:	8b 40 18             	mov    0x18(%eax),%eax
801040fd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80104108:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010410c:	85 c0                	test   %eax,%eax
8010410e:	74 13                	je     80104123 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104110:	83 ec 0c             	sub    $0xc,%esp
80104113:	50                   	push   %eax
80104114:	e8 a7 d2 ff ff       	call   801013c0 <filedup>
80104119:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010411c:	83 c4 10             	add    $0x10,%esp
8010411f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104123:	83 c6 01             	add    $0x1,%esi
80104126:	83 fe 10             	cmp    $0x10,%esi
80104129:	75 dd                	jne    80104108 <fork+0x78>
  np->cwd = idup(curproc->cwd);
8010412b:	83 ec 0c             	sub    $0xc,%esp
8010412e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104131:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104134:	e8 47 db ff ff       	call   80101c80 <idup>
80104139:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010413c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010413f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104142:	8d 47 6c             	lea    0x6c(%edi),%eax
80104145:	6a 10                	push   $0x10
80104147:	53                   	push   %ebx
80104148:	50                   	push   %eax
80104149:	e8 22 0f 00 00       	call   80105070 <safestrcpy>
  pid = np->pid;
8010414e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104151:	c7 04 24 60 46 11 80 	movl   $0x80114660,(%esp)
80104158:	e8 43 0c 00 00       	call   80104da0 <acquire>
  np->state = RUNNABLE;
8010415d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104164:	c7 04 24 60 46 11 80 	movl   $0x80114660,(%esp)
8010416b:	e8 f0 0c 00 00       	call   80104e60 <release>
  return pid;
80104170:	83 c4 10             	add    $0x10,%esp
}
80104173:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104176:	89 d8                	mov    %ebx,%eax
80104178:	5b                   	pop    %ebx
80104179:	5e                   	pop    %esi
8010417a:	5f                   	pop    %edi
8010417b:	5d                   	pop    %ebp
8010417c:	c3                   	ret    
    return -1;
8010417d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104182:	eb ef                	jmp    80104173 <fork+0xe3>
    kfree(np->kstack);
80104184:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104187:	83 ec 0c             	sub    $0xc,%esp
8010418a:	ff 73 08             	pushl  0x8(%ebx)
8010418d:	e8 2e e8 ff ff       	call   801029c0 <kfree>
    np->kstack = 0;
80104192:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104199:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
8010419c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801041a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801041a8:	eb c9                	jmp    80104173 <fork+0xe3>
801041aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041b0 <scheduler>:
{
801041b0:	f3 0f 1e fb          	endbr32 
801041b4:	55                   	push   %ebp
801041b5:	89 e5                	mov    %esp,%ebp
801041b7:	57                   	push   %edi
801041b8:	56                   	push   %esi
801041b9:	53                   	push   %ebx
801041ba:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801041bd:	e8 8e fc ff ff       	call   80103e50 <mycpu>
  c->proc = 0;
801041c2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801041c9:	00 00 00 
  struct cpu *c = mycpu();
801041cc:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801041ce:	8d 78 04             	lea    0x4(%eax),%edi
801041d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
801041d8:	fb                   	sti    
    acquire(&ptable.lock);
801041d9:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041dc:	bb 94 46 11 80       	mov    $0x80114694,%ebx
    acquire(&ptable.lock);
801041e1:	68 60 46 11 80       	push   $0x80114660
801041e6:	e8 b5 0b 00 00       	call   80104da0 <acquire>
801041eb:	83 c4 10             	add    $0x10,%esp
801041ee:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
801041f0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801041f4:	75 33                	jne    80104229 <scheduler+0x79>
      switchuvm(p);
801041f6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801041f9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801041ff:	53                   	push   %ebx
80104200:	e8 2b 32 00 00       	call   80107430 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104205:	58                   	pop    %eax
80104206:	5a                   	pop    %edx
80104207:	ff 73 1c             	pushl  0x1c(%ebx)
8010420a:	57                   	push   %edi
      p->state = RUNNING;
8010420b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104212:	e8 bc 0e 00 00       	call   801050d3 <swtch>
      switchkvm();
80104217:	e8 f4 31 00 00       	call   80107410 <switchkvm>
      c->proc = 0;
8010421c:	83 c4 10             	add    $0x10,%esp
8010421f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104226:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104229:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
8010422f:	81 fb 94 7e 11 80    	cmp    $0x80117e94,%ebx
80104235:	75 b9                	jne    801041f0 <scheduler+0x40>
    release(&ptable.lock);
80104237:	83 ec 0c             	sub    $0xc,%esp
8010423a:	68 60 46 11 80       	push   $0x80114660
8010423f:	e8 1c 0c 00 00       	call   80104e60 <release>
    sti();
80104244:	83 c4 10             	add    $0x10,%esp
80104247:	eb 8f                	jmp    801041d8 <scheduler+0x28>
80104249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104250 <sched>:
{
80104250:	f3 0f 1e fb          	endbr32 
80104254:	55                   	push   %ebp
80104255:	89 e5                	mov    %esp,%ebp
80104257:	56                   	push   %esi
80104258:	53                   	push   %ebx
  pushcli();
80104259:	e8 42 0a 00 00       	call   80104ca0 <pushcli>
  c = mycpu();
8010425e:	e8 ed fb ff ff       	call   80103e50 <mycpu>
  p = c->proc;
80104263:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104269:	e8 82 0a 00 00       	call   80104cf0 <popcli>
  if(!holding(&ptable.lock))
8010426e:	83 ec 0c             	sub    $0xc,%esp
80104271:	68 60 46 11 80       	push   $0x80114660
80104276:	e8 d5 0a 00 00       	call   80104d50 <holding>
8010427b:	83 c4 10             	add    $0x10,%esp
8010427e:	85 c0                	test   %eax,%eax
80104280:	74 4f                	je     801042d1 <sched+0x81>
  if(mycpu()->ncli != 1)
80104282:	e8 c9 fb ff ff       	call   80103e50 <mycpu>
80104287:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010428e:	75 68                	jne    801042f8 <sched+0xa8>
  if(p->state == RUNNING)
80104290:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104294:	74 55                	je     801042eb <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104296:	9c                   	pushf  
80104297:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104298:	f6 c4 02             	test   $0x2,%ah
8010429b:	75 41                	jne    801042de <sched+0x8e>
  intena = mycpu()->intena;
8010429d:	e8 ae fb ff ff       	call   80103e50 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801042a2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801042a5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801042ab:	e8 a0 fb ff ff       	call   80103e50 <mycpu>
801042b0:	83 ec 08             	sub    $0x8,%esp
801042b3:	ff 70 04             	pushl  0x4(%eax)
801042b6:	53                   	push   %ebx
801042b7:	e8 17 0e 00 00       	call   801050d3 <swtch>
  mycpu()->intena = intena;
801042bc:	e8 8f fb ff ff       	call   80103e50 <mycpu>
}
801042c1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801042c4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801042ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042cd:	5b                   	pop    %ebx
801042ce:	5e                   	pop    %esi
801042cf:	5d                   	pop    %ebp
801042d0:	c3                   	ret    
    panic("sched ptable.lock");
801042d1:	83 ec 0c             	sub    $0xc,%esp
801042d4:	68 7b 80 10 80       	push   $0x8010807b
801042d9:	e8 b2 c0 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801042de:	83 ec 0c             	sub    $0xc,%esp
801042e1:	68 a7 80 10 80       	push   $0x801080a7
801042e6:	e8 a5 c0 ff ff       	call   80100390 <panic>
    panic("sched running");
801042eb:	83 ec 0c             	sub    $0xc,%esp
801042ee:	68 99 80 10 80       	push   $0x80108099
801042f3:	e8 98 c0 ff ff       	call   80100390 <panic>
    panic("sched locks");
801042f8:	83 ec 0c             	sub    $0xc,%esp
801042fb:	68 8d 80 10 80       	push   $0x8010808d
80104300:	e8 8b c0 ff ff       	call   80100390 <panic>
80104305:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010430c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104310 <exit>:
{
80104310:	f3 0f 1e fb          	endbr32 
80104314:	55                   	push   %ebp
80104315:	89 e5                	mov    %esp,%ebp
80104317:	57                   	push   %edi
80104318:	56                   	push   %esi
80104319:	53                   	push   %ebx
8010431a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010431d:	e8 7e 09 00 00       	call   80104ca0 <pushcli>
  c = mycpu();
80104322:	e8 29 fb ff ff       	call   80103e50 <mycpu>
  p = c->proc;
80104327:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010432d:	e8 be 09 00 00       	call   80104cf0 <popcli>
  if(curproc == initproc)
80104332:	8d 5e 28             	lea    0x28(%esi),%ebx
80104335:	8d 7e 68             	lea    0x68(%esi),%edi
80104338:	39 35 08 b6 10 80    	cmp    %esi,0x8010b608
8010433e:	0f 84 fd 00 00 00    	je     80104441 <exit+0x131>
80104344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104348:	8b 03                	mov    (%ebx),%eax
8010434a:	85 c0                	test   %eax,%eax
8010434c:	74 12                	je     80104360 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010434e:	83 ec 0c             	sub    $0xc,%esp
80104351:	50                   	push   %eax
80104352:	e8 b9 d0 ff ff       	call   80101410 <fileclose>
      curproc->ofile[fd] = 0;
80104357:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010435d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104360:	83 c3 04             	add    $0x4,%ebx
80104363:	39 df                	cmp    %ebx,%edi
80104365:	75 e1                	jne    80104348 <exit+0x38>
  begin_op();
80104367:	e8 14 ef ff ff       	call   80103280 <begin_op>
  iput(curproc->cwd);
8010436c:	83 ec 0c             	sub    $0xc,%esp
8010436f:	ff 76 68             	pushl  0x68(%esi)
80104372:	e8 69 da ff ff       	call   80101de0 <iput>
  end_op();
80104377:	e8 74 ef ff ff       	call   801032f0 <end_op>
  curproc->cwd = 0;
8010437c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104383:	c7 04 24 60 46 11 80 	movl   $0x80114660,(%esp)
8010438a:	e8 11 0a 00 00       	call   80104da0 <acquire>
  wakeup1(curproc->parent);
8010438f:	8b 56 14             	mov    0x14(%esi),%edx
80104392:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104395:	b8 94 46 11 80       	mov    $0x80114694,%eax
8010439a:	eb 10                	jmp    801043ac <exit+0x9c>
8010439c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043a0:	05 e0 00 00 00       	add    $0xe0,%eax
801043a5:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
801043aa:	74 1e                	je     801043ca <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
801043ac:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043b0:	75 ee                	jne    801043a0 <exit+0x90>
801043b2:	3b 50 20             	cmp    0x20(%eax),%edx
801043b5:	75 e9                	jne    801043a0 <exit+0x90>
      p->state = RUNNABLE;
801043b7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043be:	05 e0 00 00 00       	add    $0xe0,%eax
801043c3:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
801043c8:	75 e2                	jne    801043ac <exit+0x9c>
      p->parent = initproc;
801043ca:	8b 0d 08 b6 10 80    	mov    0x8010b608,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043d0:	ba 94 46 11 80       	mov    $0x80114694,%edx
801043d5:	eb 17                	jmp    801043ee <exit+0xde>
801043d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043de:	66 90                	xchg   %ax,%ax
801043e0:	81 c2 e0 00 00 00    	add    $0xe0,%edx
801043e6:	81 fa 94 7e 11 80    	cmp    $0x80117e94,%edx
801043ec:	74 3a                	je     80104428 <exit+0x118>
    if(p->parent == curproc){
801043ee:	39 72 14             	cmp    %esi,0x14(%edx)
801043f1:	75 ed                	jne    801043e0 <exit+0xd0>
      if(p->state == ZOMBIE)
801043f3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801043f7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801043fa:	75 e4                	jne    801043e0 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043fc:	b8 94 46 11 80       	mov    $0x80114694,%eax
80104401:	eb 11                	jmp    80104414 <exit+0x104>
80104403:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104407:	90                   	nop
80104408:	05 e0 00 00 00       	add    $0xe0,%eax
8010440d:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
80104412:	74 cc                	je     801043e0 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104414:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104418:	75 ee                	jne    80104408 <exit+0xf8>
8010441a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010441d:	75 e9                	jne    80104408 <exit+0xf8>
      p->state = RUNNABLE;
8010441f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104426:	eb e0                	jmp    80104408 <exit+0xf8>
  curproc->state = ZOMBIE;
80104428:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010442f:	e8 1c fe ff ff       	call   80104250 <sched>
  panic("zombie exit");
80104434:	83 ec 0c             	sub    $0xc,%esp
80104437:	68 c8 80 10 80       	push   $0x801080c8
8010443c:	e8 4f bf ff ff       	call   80100390 <panic>
    panic("init exiting");
80104441:	83 ec 0c             	sub    $0xc,%esp
80104444:	68 bb 80 10 80       	push   $0x801080bb
80104449:	e8 42 bf ff ff       	call   80100390 <panic>
8010444e:	66 90                	xchg   %ax,%ax

80104450 <yield>:
{
80104450:	f3 0f 1e fb          	endbr32 
80104454:	55                   	push   %ebp
80104455:	89 e5                	mov    %esp,%ebp
80104457:	53                   	push   %ebx
80104458:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010445b:	68 60 46 11 80       	push   $0x80114660
80104460:	e8 3b 09 00 00       	call   80104da0 <acquire>
  pushcli();
80104465:	e8 36 08 00 00       	call   80104ca0 <pushcli>
  c = mycpu();
8010446a:	e8 e1 f9 ff ff       	call   80103e50 <mycpu>
  p = c->proc;
8010446f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104475:	e8 76 08 00 00       	call   80104cf0 <popcli>
  myproc()->state = RUNNABLE;
8010447a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104481:	e8 ca fd ff ff       	call   80104250 <sched>
  release(&ptable.lock);
80104486:	c7 04 24 60 46 11 80 	movl   $0x80114660,(%esp)
8010448d:	e8 ce 09 00 00       	call   80104e60 <release>
}
80104492:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104495:	83 c4 10             	add    $0x10,%esp
80104498:	c9                   	leave  
80104499:	c3                   	ret    
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044a0 <sleep>:
{
801044a0:	f3 0f 1e fb          	endbr32 
801044a4:	55                   	push   %ebp
801044a5:	89 e5                	mov    %esp,%ebp
801044a7:	57                   	push   %edi
801044a8:	56                   	push   %esi
801044a9:	53                   	push   %ebx
801044aa:	83 ec 0c             	sub    $0xc,%esp
801044ad:	8b 7d 08             	mov    0x8(%ebp),%edi
801044b0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801044b3:	e8 e8 07 00 00       	call   80104ca0 <pushcli>
  c = mycpu();
801044b8:	e8 93 f9 ff ff       	call   80103e50 <mycpu>
  p = c->proc;
801044bd:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044c3:	e8 28 08 00 00       	call   80104cf0 <popcli>
  if(p == 0)
801044c8:	85 db                	test   %ebx,%ebx
801044ca:	0f 84 83 00 00 00    	je     80104553 <sleep+0xb3>
  if(lk == 0)
801044d0:	85 f6                	test   %esi,%esi
801044d2:	74 72                	je     80104546 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801044d4:	81 fe 60 46 11 80    	cmp    $0x80114660,%esi
801044da:	74 4c                	je     80104528 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801044dc:	83 ec 0c             	sub    $0xc,%esp
801044df:	68 60 46 11 80       	push   $0x80114660
801044e4:	e8 b7 08 00 00       	call   80104da0 <acquire>
    release(lk);
801044e9:	89 34 24             	mov    %esi,(%esp)
801044ec:	e8 6f 09 00 00       	call   80104e60 <release>
  p->chan = chan;
801044f1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801044f4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801044fb:	e8 50 fd ff ff       	call   80104250 <sched>
  p->chan = 0;
80104500:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104507:	c7 04 24 60 46 11 80 	movl   $0x80114660,(%esp)
8010450e:	e8 4d 09 00 00       	call   80104e60 <release>
    acquire(lk);
80104513:	89 75 08             	mov    %esi,0x8(%ebp)
80104516:	83 c4 10             	add    $0x10,%esp
}
80104519:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010451c:	5b                   	pop    %ebx
8010451d:	5e                   	pop    %esi
8010451e:	5f                   	pop    %edi
8010451f:	5d                   	pop    %ebp
    acquire(lk);
80104520:	e9 7b 08 00 00       	jmp    80104da0 <acquire>
80104525:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104528:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010452b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104532:	e8 19 fd ff ff       	call   80104250 <sched>
  p->chan = 0;
80104537:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010453e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104541:	5b                   	pop    %ebx
80104542:	5e                   	pop    %esi
80104543:	5f                   	pop    %edi
80104544:	5d                   	pop    %ebp
80104545:	c3                   	ret    
    panic("sleep without lk");
80104546:	83 ec 0c             	sub    $0xc,%esp
80104549:	68 da 80 10 80       	push   $0x801080da
8010454e:	e8 3d be ff ff       	call   80100390 <panic>
    panic("sleep");
80104553:	83 ec 0c             	sub    $0xc,%esp
80104556:	68 d4 80 10 80       	push   $0x801080d4
8010455b:	e8 30 be ff ff       	call   80100390 <panic>

80104560 <wait>:
{
80104560:	f3 0f 1e fb          	endbr32 
80104564:	55                   	push   %ebp
80104565:	89 e5                	mov    %esp,%ebp
80104567:	56                   	push   %esi
80104568:	53                   	push   %ebx
  pushcli();
80104569:	e8 32 07 00 00       	call   80104ca0 <pushcli>
  c = mycpu();
8010456e:	e8 dd f8 ff ff       	call   80103e50 <mycpu>
  p = c->proc;
80104573:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104579:	e8 72 07 00 00       	call   80104cf0 <popcli>
  acquire(&ptable.lock);
8010457e:	83 ec 0c             	sub    $0xc,%esp
80104581:	68 60 46 11 80       	push   $0x80114660
80104586:	e8 15 08 00 00       	call   80104da0 <acquire>
8010458b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010458e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104590:	bb 94 46 11 80       	mov    $0x80114694,%ebx
80104595:	eb 17                	jmp    801045ae <wait+0x4e>
80104597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010459e:	66 90                	xchg   %ax,%ax
801045a0:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
801045a6:	81 fb 94 7e 11 80    	cmp    $0x80117e94,%ebx
801045ac:	74 1e                	je     801045cc <wait+0x6c>
      if(p->parent != curproc)
801045ae:	39 73 14             	cmp    %esi,0x14(%ebx)
801045b1:	75 ed                	jne    801045a0 <wait+0x40>
      if(p->state == ZOMBIE){
801045b3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801045b7:	74 37                	je     801045f0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045b9:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
      havekids = 1;
801045bf:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045c4:	81 fb 94 7e 11 80    	cmp    $0x80117e94,%ebx
801045ca:	75 e2                	jne    801045ae <wait+0x4e>
    if(!havekids || curproc->killed){
801045cc:	85 c0                	test   %eax,%eax
801045ce:	74 76                	je     80104646 <wait+0xe6>
801045d0:	8b 46 24             	mov    0x24(%esi),%eax
801045d3:	85 c0                	test   %eax,%eax
801045d5:	75 6f                	jne    80104646 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801045d7:	83 ec 08             	sub    $0x8,%esp
801045da:	68 60 46 11 80       	push   $0x80114660
801045df:	56                   	push   %esi
801045e0:	e8 bb fe ff ff       	call   801044a0 <sleep>
    havekids = 0;
801045e5:	83 c4 10             	add    $0x10,%esp
801045e8:	eb a4                	jmp    8010458e <wait+0x2e>
801045ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801045f0:	83 ec 0c             	sub    $0xc,%esp
801045f3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801045f6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801045f9:	e8 c2 e3 ff ff       	call   801029c0 <kfree>
        freevm(p->pgdir);
801045fe:	5a                   	pop    %edx
801045ff:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104602:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104609:	e8 e2 31 00 00       	call   801077f0 <freevm>
        release(&ptable.lock);
8010460e:	c7 04 24 60 46 11 80 	movl   $0x80114660,(%esp)
        p->pid = 0;
80104615:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010461c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104623:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104627:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010462e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104635:	e8 26 08 00 00       	call   80104e60 <release>
        return pid;
8010463a:	83 c4 10             	add    $0x10,%esp
}
8010463d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104640:	89 f0                	mov    %esi,%eax
80104642:	5b                   	pop    %ebx
80104643:	5e                   	pop    %esi
80104644:	5d                   	pop    %ebp
80104645:	c3                   	ret    
      release(&ptable.lock);
80104646:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104649:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010464e:	68 60 46 11 80       	push   $0x80114660
80104653:	e8 08 08 00 00       	call   80104e60 <release>
      return -1;
80104658:	83 c4 10             	add    $0x10,%esp
8010465b:	eb e0                	jmp    8010463d <wait+0xdd>
8010465d:	8d 76 00             	lea    0x0(%esi),%esi

80104660 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104660:	f3 0f 1e fb          	endbr32 
80104664:	55                   	push   %ebp
80104665:	89 e5                	mov    %esp,%ebp
80104667:	53                   	push   %ebx
80104668:	83 ec 10             	sub    $0x10,%esp
8010466b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010466e:	68 60 46 11 80       	push   $0x80114660
80104673:	e8 28 07 00 00       	call   80104da0 <acquire>
80104678:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010467b:	b8 94 46 11 80       	mov    $0x80114694,%eax
80104680:	eb 12                	jmp    80104694 <wakeup+0x34>
80104682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104688:	05 e0 00 00 00       	add    $0xe0,%eax
8010468d:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
80104692:	74 1e                	je     801046b2 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104694:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104698:	75 ee                	jne    80104688 <wakeup+0x28>
8010469a:	3b 58 20             	cmp    0x20(%eax),%ebx
8010469d:	75 e9                	jne    80104688 <wakeup+0x28>
      p->state = RUNNABLE;
8010469f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046a6:	05 e0 00 00 00       	add    $0xe0,%eax
801046ab:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
801046b0:	75 e2                	jne    80104694 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
801046b2:	c7 45 08 60 46 11 80 	movl   $0x80114660,0x8(%ebp)
}
801046b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046bc:	c9                   	leave  
  release(&ptable.lock);
801046bd:	e9 9e 07 00 00       	jmp    80104e60 <release>
801046c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046d0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801046d0:	f3 0f 1e fb          	endbr32 
801046d4:	55                   	push   %ebp
801046d5:	89 e5                	mov    %esp,%ebp
801046d7:	53                   	push   %ebx
801046d8:	83 ec 10             	sub    $0x10,%esp
801046db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801046de:	68 60 46 11 80       	push   $0x80114660
801046e3:	e8 b8 06 00 00       	call   80104da0 <acquire>
801046e8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046eb:	b8 94 46 11 80       	mov    $0x80114694,%eax
801046f0:	eb 12                	jmp    80104704 <kill+0x34>
801046f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046f8:	05 e0 00 00 00       	add    $0xe0,%eax
801046fd:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
80104702:	74 34                	je     80104738 <kill+0x68>
    if(p->pid == pid){
80104704:	39 58 10             	cmp    %ebx,0x10(%eax)
80104707:	75 ef                	jne    801046f8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104709:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010470d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104714:	75 07                	jne    8010471d <kill+0x4d>
        p->state = RUNNABLE;
80104716:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010471d:	83 ec 0c             	sub    $0xc,%esp
80104720:	68 60 46 11 80       	push   $0x80114660
80104725:	e8 36 07 00 00       	call   80104e60 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010472a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010472d:	83 c4 10             	add    $0x10,%esp
80104730:	31 c0                	xor    %eax,%eax
}
80104732:	c9                   	leave  
80104733:	c3                   	ret    
80104734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104738:	83 ec 0c             	sub    $0xc,%esp
8010473b:	68 60 46 11 80       	push   $0x80114660
80104740:	e8 1b 07 00 00       	call   80104e60 <release>
}
80104745:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104748:	83 c4 10             	add    $0x10,%esp
8010474b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104750:	c9                   	leave  
80104751:	c3                   	ret    
80104752:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104760 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104760:	f3 0f 1e fb          	endbr32 
80104764:	55                   	push   %ebp
80104765:	89 e5                	mov    %esp,%ebp
80104767:	57                   	push   %edi
80104768:	56                   	push   %esi
80104769:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010476c:	53                   	push   %ebx
8010476d:	bb 00 47 11 80       	mov    $0x80114700,%ebx
80104772:	83 ec 3c             	sub    $0x3c,%esp
80104775:	eb 2b                	jmp    801047a2 <procdump+0x42>
80104777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010477e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104780:	83 ec 0c             	sub    $0xc,%esp
80104783:	68 df 84 10 80       	push   $0x801084df
80104788:	e8 23 bf ff ff       	call   801006b0 <cprintf>
8010478d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104790:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
80104796:	81 fb 00 7f 11 80    	cmp    $0x80117f00,%ebx
8010479c:	0f 84 8e 00 00 00    	je     80104830 <procdump+0xd0>
    if(p->state == UNUSED)
801047a2:	8b 43 a0             	mov    -0x60(%ebx),%eax
801047a5:	85 c0                	test   %eax,%eax
801047a7:	74 e7                	je     80104790 <procdump+0x30>
      state = "???";
801047a9:	ba eb 80 10 80       	mov    $0x801080eb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801047ae:	83 f8 05             	cmp    $0x5,%eax
801047b1:	77 11                	ja     801047c4 <procdump+0x64>
801047b3:	8b 14 85 64 81 10 80 	mov    -0x7fef7e9c(,%eax,4),%edx
      state = "???";
801047ba:	b8 eb 80 10 80       	mov    $0x801080eb,%eax
801047bf:	85 d2                	test   %edx,%edx
801047c1:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801047c4:	53                   	push   %ebx
801047c5:	52                   	push   %edx
801047c6:	ff 73 a4             	pushl  -0x5c(%ebx)
801047c9:	68 ef 80 10 80       	push   $0x801080ef
801047ce:	e8 dd be ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801047d3:	83 c4 10             	add    $0x10,%esp
801047d6:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801047da:	75 a4                	jne    80104780 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801047dc:	83 ec 08             	sub    $0x8,%esp
801047df:	8d 45 c0             	lea    -0x40(%ebp),%eax
801047e2:	8d 7d c0             	lea    -0x40(%ebp),%edi
801047e5:	50                   	push   %eax
801047e6:	8b 43 b0             	mov    -0x50(%ebx),%eax
801047e9:	8b 40 0c             	mov    0xc(%eax),%eax
801047ec:	83 c0 08             	add    $0x8,%eax
801047ef:	50                   	push   %eax
801047f0:	e8 4b 04 00 00       	call   80104c40 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801047f5:	83 c4 10             	add    $0x10,%esp
801047f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ff:	90                   	nop
80104800:	8b 17                	mov    (%edi),%edx
80104802:	85 d2                	test   %edx,%edx
80104804:	0f 84 76 ff ff ff    	je     80104780 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010480a:	83 ec 08             	sub    $0x8,%esp
8010480d:	83 c7 04             	add    $0x4,%edi
80104810:	52                   	push   %edx
80104811:	68 41 7b 10 80       	push   $0x80107b41
80104816:	e8 95 be ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010481b:	83 c4 10             	add    $0x10,%esp
8010481e:	39 fe                	cmp    %edi,%esi
80104820:	75 de                	jne    80104800 <procdump+0xa0>
80104822:	e9 59 ff ff ff       	jmp    80104780 <procdump+0x20>
80104827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010482e:	66 90                	xchg   %ax,%ax
  }
}
80104830:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104833:	5b                   	pop    %ebx
80104834:	5e                   	pop    %esi
80104835:	5f                   	pop    %edi
80104836:	5d                   	pop    %ebp
80104837:	c3                   	ret    
80104838:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010483f:	90                   	nop

80104840 <find_next_prime_num>:

// next prime number
int 
find_next_prime_num(int n)    
{    
80104840:	f3 0f 1e fb          	endbr32 
80104844:	55                   	push   %ebp
80104845:	89 e5                	mov    %esp,%ebp
80104847:	56                   	push   %esi
  for(int i=n+1;i>0;i++)
80104848:	8b 45 08             	mov    0x8(%ebp),%eax
{    
8010484b:	53                   	push   %ebx
  for(int i=n+1;i>0;i++)
8010484c:	8d 58 01             	lea    0x1(%eax),%ebx
8010484f:	85 db                	test   %ebx,%ebx
80104851:	7e 29                	jle    8010487c <find_next_prime_num+0x3c>
80104853:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104857:	90                   	nop
  {
    int count=0;
    for(int j=1;j<=i;j++)
80104858:	b9 01 00 00 00       	mov    $0x1,%ecx
    int count=0;
8010485d:	31 f6                	xor    %esi,%esi
8010485f:	90                   	nop
    {
      if(i%j==0)
80104860:	89 d8                	mov    %ebx,%eax
80104862:	99                   	cltd   
80104863:	f7 f9                	idiv   %ecx
      count++;
80104865:	83 fa 01             	cmp    $0x1,%edx
80104868:	83 d6 00             	adc    $0x0,%esi
    for(int j=1;j<=i;j++)
8010486b:	83 c1 01             	add    $0x1,%ecx
8010486e:	39 d9                	cmp    %ebx,%ecx
80104870:	7e ee                	jle    80104860 <find_next_prime_num+0x20>
    }
    if(count==2)
80104872:	83 fe 02             	cmp    $0x2,%esi
80104875:	74 07                	je     8010487e <find_next_prime_num+0x3e>
  for(int i=n+1;i>0;i++)
80104877:	83 c3 01             	add    $0x1,%ebx
8010487a:	eb dc                	jmp    80104858 <find_next_prime_num+0x18>
      return i;
  }
  return 0;
8010487c:	31 db                	xor    %ebx,%ebx
}
8010487e:	89 d8                	mov    %ebx,%eax
80104880:	5b                   	pop    %ebx
80104881:	5e                   	pop    %esi
80104882:	5d                   	pop    %ebp
80104883:	c3                   	ret    
80104884:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010488b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010488f:	90                   	nop

80104890 <get_call_count>:

// get call count
int 
get_call_count(int sys_call_num)
{
80104890:	f3 0f 1e fb          	endbr32 
80104894:	55                   	push   %ebp
80104895:	89 e5                	mov    %esp,%ebp
80104897:	53                   	push   %ebx
80104898:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010489b:	e8 00 04 00 00       	call   80104ca0 <pushcli>
  c = mycpu();
801048a0:	e8 ab f5 ff ff       	call   80103e50 <mycpu>
  p = c->proc;
801048a5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801048ab:	e8 40 04 00 00       	call   80104cf0 <popcli>
  return myproc()->sys_call_count[sys_call_num];
801048b0:	8b 45 08             	mov    0x8(%ebp),%eax
801048b3:	8b 44 83 7c          	mov    0x7c(%ebx,%eax,4),%eax
}
801048b7:	83 c4 04             	add    $0x4,%esp
801048ba:	5b                   	pop    %ebx
801048bb:	5d                   	pop    %ebp
801048bc:	c3                   	ret    
801048bd:	8d 76 00             	lea    0x0(%esi),%esi

801048c0 <get_most_caller>:

// get most caller
int 
get_most_caller(int sys_call_num)
{
801048c0:	f3 0f 1e fb          	endbr32 
801048c4:	55                   	push   %ebp
  int most_call = 0;

  struct proc *p;

  // acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048c5:	b8 94 46 11 80       	mov    $0x80114694,%eax
  int most_call = 0;
801048ca:	31 c9                	xor    %ecx,%ecx
{
801048cc:	89 e5                	mov    %esp,%ebp
801048ce:	56                   	push   %esi
  int caller_id = -1;
801048cf:	be ff ff ff ff       	mov    $0xffffffff,%esi
{
801048d4:	53                   	push   %ebx
801048d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048df:	90                   	nop
    if(p->sys_call_count[sys_call_num] > most_call){
801048e0:	8b 54 98 7c          	mov    0x7c(%eax,%ebx,4),%edx
801048e4:	39 ca                	cmp    %ecx,%edx
801048e6:	7e 05                	jle    801048ed <get_most_caller+0x2d>
      most_call = p->sys_call_count[sys_call_num];
      caller_id = p->pid;
801048e8:	8b 70 10             	mov    0x10(%eax),%esi
801048eb:	89 d1                	mov    %edx,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048ed:	05 e0 00 00 00       	add    $0xe0,%eax
801048f2:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
801048f7:	75 e7                	jne    801048e0 <get_most_caller+0x20>
    }
  }

  return caller_id;
}
801048f9:	89 f0                	mov    %esi,%eax
801048fb:	5b                   	pop    %ebx
801048fc:	5e                   	pop    %esi
801048fd:	5d                   	pop    %ebp
801048fe:	c3                   	ret    
801048ff:	90                   	nop

80104900 <wait_for_process>:


// wait for a process to finish
void 
wait_for_process(int pid)
{
80104900:	f3 0f 1e fb          	endbr32 
80104904:	55                   	push   %ebp
80104905:	89 e5                	mov    %esp,%ebp
80104907:	8b 55 08             	mov    0x8(%ebp),%edx
  struct proc *p;

  int pid_exist = 1;
  while(pid_exist) {
8010490a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pid_exist = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104910:	b8 94 46 11 80       	mov    $0x80114694,%eax
80104915:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->pid == pid){
80104918:	39 50 10             	cmp    %edx,0x10(%eax)
8010491b:	74 f3                	je     80104910 <wait_for_process+0x10>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010491d:	05 e0 00 00 00       	add    $0xe0,%eax
80104922:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
80104927:	75 ef                	jne    80104918 <wait_for_process+0x18>
        pid_exist = 1;
        break;
      }
  }
}
80104929:	5d                   	pop    %ebp
8010492a:	c3                   	ret    
8010492b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010492f:	90                   	nop

80104930 <sem_init>:

// semaphore operations

int
sem_init(int i, int  v)
{
80104930:	f3 0f 1e fb          	endbr32 
80104934:	55                   	push   %ebp
80104935:	89 e5                	mov    %esp,%ebp
80104937:	83 ec 08             	sub    $0x8,%esp
8010493a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  semaphores[i].value = v;
8010493d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104940:	8d 14 49             	lea    (%ecx,%ecx,2),%edx
80104943:	c1 e2 05             	shl    $0x5,%edx
80104946:	89 82 a0 42 11 80    	mov    %eax,-0x7feebd60(%edx)
  for(int j=0; j < 10; j++) {
8010494c:	31 c0                	xor    %eax,%eax
8010494e:	66 90                	xchg   %ax,%ax
    semaphores[i].list[j] = 0;
80104950:	c7 84 82 d8 42 11 80 	movl   $0x0,-0x7feebd28(%edx,%eax,4)
80104957:	00 00 00 00 
  for(int j=0; j < 10; j++) {
8010495b:	83 c0 01             	add    $0x1,%eax
8010495e:	83 f8 0a             	cmp    $0xa,%eax
80104961:	75 ed                	jne    80104950 <sem_init+0x20>
  }
  initlock(&(semaphores[i].lock), (char*)i + '0');
80104963:	83 ec 08             	sub    $0x8,%esp
80104966:	83 c1 30             	add    $0x30,%ecx
80104969:	81 c2 a4 42 11 80    	add    $0x801142a4,%edx
8010496f:	51                   	push   %ecx
80104970:	52                   	push   %edx
80104971:	e8 aa 02 00 00       	call   80104c20 <initlock>
  return 0;
}
80104976:	31 c0                	xor    %eax,%eax
80104978:	c9                   	leave  
80104979:	c3                   	ret    
8010497a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104980 <sem_acquire>:

int
sem_acquire(int i)
{
80104980:	f3 0f 1e fb          	endbr32 
80104984:	55                   	push   %ebp
80104985:	89 e5                	mov    %esp,%ebp
80104987:	57                   	push   %edi
80104988:	56                   	push   %esi
80104989:	53                   	push   %ebx
8010498a:	83 ec 0c             	sub    $0xc,%esp
8010498d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104990:	e8 0b 03 00 00       	call   80104ca0 <pushcli>
  c = mycpu();
80104995:	e8 b6 f4 ff ff       	call   80103e50 <mycpu>
  struct proc *curproc = myproc();
  acquire(&(semaphores[i].lock));
8010499a:	8d 1c 5b             	lea    (%ebx,%ebx,2),%ebx
8010499d:	c1 e3 05             	shl    $0x5,%ebx
  p = c->proc;
801049a0:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801049a6:	e8 45 03 00 00       	call   80104cf0 <popcli>
  acquire(&(semaphores[i].lock));
801049ab:	8d bb a4 42 11 80    	lea    -0x7feebd5c(%ebx),%edi
801049b1:	83 ec 0c             	sub    $0xc,%esp
801049b4:	57                   	push   %edi
801049b5:	e8 e6 03 00 00       	call   80104da0 <acquire>
  semaphores[i].value -= 1;
801049ba:	8b 83 a0 42 11 80    	mov    -0x7feebd60(%ebx),%eax
  if(semaphores[i].value < 0) {
801049c0:	83 c4 10             	add    $0x10,%esp
  semaphores[i].value -= 1;
801049c3:	83 e8 01             	sub    $0x1,%eax
801049c6:	89 83 a0 42 11 80    	mov    %eax,-0x7feebd60(%ebx)
  if(semaphores[i].value < 0) {
801049cc:	85 c0                	test   %eax,%eax
801049ce:	78 18                	js     801049e8 <sem_acquire+0x68>
      semaphores[i].list[j] = curproc;
      break;
    }
    sleep(curproc, &(semaphores[i].lock));
  }
  release(&(semaphores[i].lock));
801049d0:	83 ec 0c             	sub    $0xc,%esp
801049d3:	57                   	push   %edi
801049d4:	e8 87 04 00 00       	call   80104e60 <release>
  return 0;
}
801049d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049dc:	31 c0                	xor    %eax,%eax
801049de:	5b                   	pop    %ebx
801049df:	5e                   	pop    %esi
801049e0:	5f                   	pop    %edi
801049e1:	5d                   	pop    %ebp
801049e2:	c3                   	ret    
801049e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049e7:	90                   	nop
    sleep(curproc, &(semaphores[i].lock));
801049e8:	83 ec 08             	sub    $0x8,%esp
      semaphores[i].list[j] = curproc;
801049eb:	89 b3 d8 42 11 80    	mov    %esi,-0x7feebd28(%ebx)
    sleep(curproc, &(semaphores[i].lock));
801049f1:	57                   	push   %edi
801049f2:	56                   	push   %esi
801049f3:	e8 a8 fa ff ff       	call   801044a0 <sleep>
801049f8:	83 c4 10             	add    $0x10,%esp
801049fb:	eb d3                	jmp    801049d0 <sem_acquire+0x50>
801049fd:	8d 76 00             	lea    0x0(%esi),%esi

80104a00 <sem_release>:

int
sem_release(int i)
{
80104a00:	f3 0f 1e fb          	endbr32 
80104a04:	55                   	push   %ebp
80104a05:	89 e5                	mov    %esp,%ebp
80104a07:	56                   	push   %esi
80104a08:	8b 45 08             	mov    0x8(%ebp),%eax
80104a0b:	53                   	push   %ebx
80104a0c:	8d 1c 40             	lea    (%eax,%eax,2),%ebx
80104a0f:	c1 e3 05             	shl    $0x5,%ebx
  acquire(&(semaphores[i].lock));
80104a12:	83 ec 0c             	sub    $0xc,%esp
80104a15:	8d b3 a4 42 11 80    	lea    -0x7feebd5c(%ebx),%esi
80104a1b:	56                   	push   %esi
80104a1c:	e8 7f 03 00 00       	call   80104da0 <acquire>
  struct proc* p = 0;
  semaphores[i].value += 1;
80104a21:	8b 83 a0 42 11 80    	mov    -0x7feebd60(%ebx),%eax
  if(semaphores[i].value <= 0) {
80104a27:	83 c4 10             	add    $0x10,%esp
  semaphores[i].value += 1;
80104a2a:	83 c0 01             	add    $0x1,%eax
80104a2d:	89 83 a0 42 11 80    	mov    %eax,-0x7feebd60(%ebx)
  if(semaphores[i].value <= 0) {
80104a33:	85 c0                	test   %eax,%eax
80104a35:	7e 19                	jle    80104a50 <sem_release+0x50>
    for(int j=0; j<9; j++) {
      semaphores[i].list[j] = semaphores[i].list[j+1];
    }
    wakeup(p);
  }
  release(&(semaphores[i].lock));
80104a37:	83 ec 0c             	sub    $0xc,%esp
80104a3a:	56                   	push   %esi
80104a3b:	e8 20 04 00 00       	call   80104e60 <release>
  return 0;
}
80104a40:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a43:	31 c0                	xor    %eax,%eax
80104a45:	5b                   	pop    %ebx
80104a46:	5e                   	pop    %esi
80104a47:	5d                   	pop    %ebp
80104a48:	c3                   	ret    
80104a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p = semaphores[i].list[0];
80104a50:	8b 8b d8 42 11 80    	mov    -0x7feebd28(%ebx),%ecx
    for(int j=0; j<9; j++) {
80104a56:	8d 53 24             	lea    0x24(%ebx),%edx
80104a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      semaphores[i].list[j] = semaphores[i].list[j+1];
80104a60:	8b 83 dc 42 11 80    	mov    -0x7feebd24(%ebx),%eax
80104a66:	83 c3 04             	add    $0x4,%ebx
80104a69:	89 83 d4 42 11 80    	mov    %eax,-0x7feebd2c(%ebx)
    for(int j=0; j<9; j++) {
80104a6f:	39 d3                	cmp    %edx,%ebx
80104a71:	75 ed                	jne    80104a60 <sem_release+0x60>
    wakeup(p);
80104a73:	83 ec 0c             	sub    $0xc,%esp
80104a76:	51                   	push   %ecx
80104a77:	e8 e4 fb ff ff       	call   80104660 <wakeup>
80104a7c:	83 c4 10             	add    $0x10,%esp
80104a7f:	eb b6                	jmp    80104a37 <sem_release+0x37>
80104a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a8f:	90                   	nop

80104a90 <multiple_acquire>:

// multipke acquire

void
multiple_acquire(int cnt)
{
80104a90:	f3 0f 1e fb          	endbr32 
80104a94:	55                   	push   %ebp
80104a95:	89 e5                	mov    %esp,%ebp
80104a97:	53                   	push   %ebx
80104a98:	83 ec 04             	sub    $0x4,%esp
80104a9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (cnt == 0)
80104a9e:	85 db                	test   %ebx,%ebx
80104aa0:	74 28                	je     80104aca <multiple_acquire+0x3a>
80104aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  {
    release(&tickslock);
    return;
  }
  cprintf("Acquiring... cnt = %d\n", cnt);
80104aa8:	83 ec 08             	sub    $0x8,%esp
80104aab:	53                   	push   %ebx
80104aac:	68 f8 80 10 80       	push   $0x801080f8
80104ab1:	e8 fa bb ff ff       	call   801006b0 <cprintf>
  acquire(&tickslock);
80104ab6:	c7 04 24 a0 7e 11 80 	movl   $0x80117ea0,(%esp)
80104abd:	e8 de 02 00 00       	call   80104da0 <acquire>
  if (cnt == 0)
80104ac2:	83 c4 10             	add    $0x10,%esp
80104ac5:	83 eb 01             	sub    $0x1,%ebx
80104ac8:	75 de                	jne    80104aa8 <multiple_acquire+0x18>
    release(&tickslock);
80104aca:	c7 45 08 a0 7e 11 80 	movl   $0x80117ea0,0x8(%ebp)
  multiple_acquire(cnt - 1);

80104ad1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ad4:	c9                   	leave  
    release(&tickslock);
80104ad5:	e9 86 03 00 00       	jmp    80104e60 <release>
80104ada:	66 90                	xchg   %ax,%ax
80104adc:	66 90                	xchg   %ax,%ax
80104ade:	66 90                	xchg   %ax,%ax

80104ae0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104ae0:	f3 0f 1e fb          	endbr32 
80104ae4:	55                   	push   %ebp
80104ae5:	89 e5                	mov    %esp,%ebp
80104ae7:	53                   	push   %ebx
80104ae8:	83 ec 0c             	sub    $0xc,%esp
80104aeb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104aee:	68 7c 81 10 80       	push   $0x8010817c
80104af3:	8d 43 04             	lea    0x4(%ebx),%eax
80104af6:	50                   	push   %eax
80104af7:	e8 24 01 00 00       	call   80104c20 <initlock>
  lk->name = name;
80104afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104aff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104b05:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104b08:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104b0f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104b12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b15:	c9                   	leave  
80104b16:	c3                   	ret    
80104b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b1e:	66 90                	xchg   %ax,%ax

80104b20 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104b20:	f3 0f 1e fb          	endbr32 
80104b24:	55                   	push   %ebp
80104b25:	89 e5                	mov    %esp,%ebp
80104b27:	56                   	push   %esi
80104b28:	53                   	push   %ebx
80104b29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b2c:	8d 73 04             	lea    0x4(%ebx),%esi
80104b2f:	83 ec 0c             	sub    $0xc,%esp
80104b32:	56                   	push   %esi
80104b33:	e8 68 02 00 00       	call   80104da0 <acquire>
  while (lk->locked) {
80104b38:	8b 13                	mov    (%ebx),%edx
80104b3a:	83 c4 10             	add    $0x10,%esp
80104b3d:	85 d2                	test   %edx,%edx
80104b3f:	74 1a                	je     80104b5b <acquiresleep+0x3b>
80104b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104b48:	83 ec 08             	sub    $0x8,%esp
80104b4b:	56                   	push   %esi
80104b4c:	53                   	push   %ebx
80104b4d:	e8 4e f9 ff ff       	call   801044a0 <sleep>
  while (lk->locked) {
80104b52:	8b 03                	mov    (%ebx),%eax
80104b54:	83 c4 10             	add    $0x10,%esp
80104b57:	85 c0                	test   %eax,%eax
80104b59:	75 ed                	jne    80104b48 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104b5b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104b61:	e8 7a f3 ff ff       	call   80103ee0 <myproc>
80104b66:	8b 40 10             	mov    0x10(%eax),%eax
80104b69:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104b6c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104b6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b72:	5b                   	pop    %ebx
80104b73:	5e                   	pop    %esi
80104b74:	5d                   	pop    %ebp
  release(&lk->lk);
80104b75:	e9 e6 02 00 00       	jmp    80104e60 <release>
80104b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b80 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104b80:	f3 0f 1e fb          	endbr32 
80104b84:	55                   	push   %ebp
80104b85:	89 e5                	mov    %esp,%ebp
80104b87:	56                   	push   %esi
80104b88:	53                   	push   %ebx
80104b89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b8c:	8d 73 04             	lea    0x4(%ebx),%esi
80104b8f:	83 ec 0c             	sub    $0xc,%esp
80104b92:	56                   	push   %esi
80104b93:	e8 08 02 00 00       	call   80104da0 <acquire>
  lk->locked = 0;
80104b98:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104b9e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104ba5:	89 1c 24             	mov    %ebx,(%esp)
80104ba8:	e8 b3 fa ff ff       	call   80104660 <wakeup>
  release(&lk->lk);
80104bad:	89 75 08             	mov    %esi,0x8(%ebp)
80104bb0:	83 c4 10             	add    $0x10,%esp
}
80104bb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bb6:	5b                   	pop    %ebx
80104bb7:	5e                   	pop    %esi
80104bb8:	5d                   	pop    %ebp
  release(&lk->lk);
80104bb9:	e9 a2 02 00 00       	jmp    80104e60 <release>
80104bbe:	66 90                	xchg   %ax,%ax

80104bc0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104bc0:	f3 0f 1e fb          	endbr32 
80104bc4:	55                   	push   %ebp
80104bc5:	89 e5                	mov    %esp,%ebp
80104bc7:	57                   	push   %edi
80104bc8:	31 ff                	xor    %edi,%edi
80104bca:	56                   	push   %esi
80104bcb:	53                   	push   %ebx
80104bcc:	83 ec 18             	sub    $0x18,%esp
80104bcf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104bd2:	8d 73 04             	lea    0x4(%ebx),%esi
80104bd5:	56                   	push   %esi
80104bd6:	e8 c5 01 00 00       	call   80104da0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104bdb:	8b 03                	mov    (%ebx),%eax
80104bdd:	83 c4 10             	add    $0x10,%esp
80104be0:	85 c0                	test   %eax,%eax
80104be2:	75 1c                	jne    80104c00 <holdingsleep+0x40>
  release(&lk->lk);
80104be4:	83 ec 0c             	sub    $0xc,%esp
80104be7:	56                   	push   %esi
80104be8:	e8 73 02 00 00       	call   80104e60 <release>
  return r;
}
80104bed:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bf0:	89 f8                	mov    %edi,%eax
80104bf2:	5b                   	pop    %ebx
80104bf3:	5e                   	pop    %esi
80104bf4:	5f                   	pop    %edi
80104bf5:	5d                   	pop    %ebp
80104bf6:	c3                   	ret    
80104bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bfe:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104c00:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104c03:	e8 d8 f2 ff ff       	call   80103ee0 <myproc>
80104c08:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c0b:	0f 94 c0             	sete   %al
80104c0e:	0f b6 c0             	movzbl %al,%eax
80104c11:	89 c7                	mov    %eax,%edi
80104c13:	eb cf                	jmp    80104be4 <holdingsleep+0x24>
80104c15:	66 90                	xchg   %ax,%ax
80104c17:	66 90                	xchg   %ax,%ax
80104c19:	66 90                	xchg   %ax,%ax
80104c1b:	66 90                	xchg   %ax,%ax
80104c1d:	66 90                	xchg   %ax,%ax
80104c1f:	90                   	nop

80104c20 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104c20:	f3 0f 1e fb          	endbr32 
80104c24:	55                   	push   %ebp
80104c25:	89 e5                	mov    %esp,%ebp
80104c27:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104c2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104c2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104c33:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104c36:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104c3d:	5d                   	pop    %ebp
80104c3e:	c3                   	ret    
80104c3f:	90                   	nop

80104c40 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104c40:	f3 0f 1e fb          	endbr32 
80104c44:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c45:	31 d2                	xor    %edx,%edx
{
80104c47:	89 e5                	mov    %esp,%ebp
80104c49:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104c4a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104c4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104c50:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104c53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c57:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c58:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104c5e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104c64:	77 1a                	ja     80104c80 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104c66:	8b 58 04             	mov    0x4(%eax),%ebx
80104c69:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104c6c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104c6f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c71:	83 fa 0a             	cmp    $0xa,%edx
80104c74:	75 e2                	jne    80104c58 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104c76:	5b                   	pop    %ebx
80104c77:	5d                   	pop    %ebp
80104c78:	c3                   	ret    
80104c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104c80:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104c83:	8d 51 28             	lea    0x28(%ecx),%edx
80104c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104c90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104c96:	83 c0 04             	add    $0x4,%eax
80104c99:	39 d0                	cmp    %edx,%eax
80104c9b:	75 f3                	jne    80104c90 <getcallerpcs+0x50>
}
80104c9d:	5b                   	pop    %ebx
80104c9e:	5d                   	pop    %ebp
80104c9f:	c3                   	ret    

80104ca0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ca0:	f3 0f 1e fb          	endbr32 
80104ca4:	55                   	push   %ebp
80104ca5:	89 e5                	mov    %esp,%ebp
80104ca7:	53                   	push   %ebx
80104ca8:	83 ec 04             	sub    $0x4,%esp
80104cab:	9c                   	pushf  
80104cac:	5b                   	pop    %ebx
  asm volatile("cli");
80104cad:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104cae:	e8 9d f1 ff ff       	call   80103e50 <mycpu>
80104cb3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104cb9:	85 c0                	test   %eax,%eax
80104cbb:	74 13                	je     80104cd0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104cbd:	e8 8e f1 ff ff       	call   80103e50 <mycpu>
80104cc2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104cc9:	83 c4 04             	add    $0x4,%esp
80104ccc:	5b                   	pop    %ebx
80104ccd:	5d                   	pop    %ebp
80104cce:	c3                   	ret    
80104ccf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104cd0:	e8 7b f1 ff ff       	call   80103e50 <mycpu>
80104cd5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104cdb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104ce1:	eb da                	jmp    80104cbd <pushcli+0x1d>
80104ce3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104cf0 <popcli>:

void
popcli(void)
{
80104cf0:	f3 0f 1e fb          	endbr32 
80104cf4:	55                   	push   %ebp
80104cf5:	89 e5                	mov    %esp,%ebp
80104cf7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104cfa:	9c                   	pushf  
80104cfb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104cfc:	f6 c4 02             	test   $0x2,%ah
80104cff:	75 31                	jne    80104d32 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104d01:	e8 4a f1 ff ff       	call   80103e50 <mycpu>
80104d06:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104d0d:	78 30                	js     80104d3f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d0f:	e8 3c f1 ff ff       	call   80103e50 <mycpu>
80104d14:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104d1a:	85 d2                	test   %edx,%edx
80104d1c:	74 02                	je     80104d20 <popcli+0x30>
    sti();
}
80104d1e:	c9                   	leave  
80104d1f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d20:	e8 2b f1 ff ff       	call   80103e50 <mycpu>
80104d25:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104d2b:	85 c0                	test   %eax,%eax
80104d2d:	74 ef                	je     80104d1e <popcli+0x2e>
  asm volatile("sti");
80104d2f:	fb                   	sti    
}
80104d30:	c9                   	leave  
80104d31:	c3                   	ret    
    panic("popcli - interruptible");
80104d32:	83 ec 0c             	sub    $0xc,%esp
80104d35:	68 87 81 10 80       	push   $0x80108187
80104d3a:	e8 51 b6 ff ff       	call   80100390 <panic>
    panic("popcli");
80104d3f:	83 ec 0c             	sub    $0xc,%esp
80104d42:	68 9e 81 10 80       	push   $0x8010819e
80104d47:	e8 44 b6 ff ff       	call   80100390 <panic>
80104d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d50 <holding>:
{
80104d50:	f3 0f 1e fb          	endbr32 
80104d54:	55                   	push   %ebp
80104d55:	89 e5                	mov    %esp,%ebp
80104d57:	56                   	push   %esi
80104d58:	53                   	push   %ebx
80104d59:	8b 75 08             	mov    0x8(%ebp),%esi
80104d5c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104d5e:	e8 3d ff ff ff       	call   80104ca0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d63:	8b 06                	mov    (%esi),%eax
80104d65:	85 c0                	test   %eax,%eax
80104d67:	75 0f                	jne    80104d78 <holding+0x28>
  popcli();
80104d69:	e8 82 ff ff ff       	call   80104cf0 <popcli>
}
80104d6e:	89 d8                	mov    %ebx,%eax
80104d70:	5b                   	pop    %ebx
80104d71:	5e                   	pop    %esi
80104d72:	5d                   	pop    %ebp
80104d73:	c3                   	ret    
80104d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104d78:	8b 5e 08             	mov    0x8(%esi),%ebx
80104d7b:	e8 d0 f0 ff ff       	call   80103e50 <mycpu>
80104d80:	39 c3                	cmp    %eax,%ebx
80104d82:	0f 94 c3             	sete   %bl
  popcli();
80104d85:	e8 66 ff ff ff       	call   80104cf0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104d8a:	0f b6 db             	movzbl %bl,%ebx
}
80104d8d:	89 d8                	mov    %ebx,%eax
80104d8f:	5b                   	pop    %ebx
80104d90:	5e                   	pop    %esi
80104d91:	5d                   	pop    %ebp
80104d92:	c3                   	ret    
80104d93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104da0 <acquire>:
{
80104da0:	f3 0f 1e fb          	endbr32 
80104da4:	55                   	push   %ebp
80104da5:	89 e5                	mov    %esp,%ebp
80104da7:	56                   	push   %esi
80104da8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104da9:	e8 f2 fe ff ff       	call   80104ca0 <pushcli>
  if(holding(lk))
80104dae:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104db1:	83 ec 0c             	sub    $0xc,%esp
80104db4:	53                   	push   %ebx
80104db5:	e8 96 ff ff ff       	call   80104d50 <holding>
80104dba:	83 c4 10             	add    $0x10,%esp
80104dbd:	85 c0                	test   %eax,%eax
80104dbf:	0f 85 7f 00 00 00    	jne    80104e44 <acquire+0xa4>
80104dc5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104dc7:	ba 01 00 00 00       	mov    $0x1,%edx
80104dcc:	eb 05                	jmp    80104dd3 <acquire+0x33>
80104dce:	66 90                	xchg   %ax,%ax
80104dd0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104dd3:	89 d0                	mov    %edx,%eax
80104dd5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104dd8:	85 c0                	test   %eax,%eax
80104dda:	75 f4                	jne    80104dd0 <acquire+0x30>
  __sync_synchronize();
80104ddc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104de1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104de4:	e8 67 f0 ff ff       	call   80103e50 <mycpu>
80104de9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104dec:	89 e8                	mov    %ebp,%eax
80104dee:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104df0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104df6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104dfc:	77 22                	ja     80104e20 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104dfe:	8b 50 04             	mov    0x4(%eax),%edx
80104e01:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104e05:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104e08:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104e0a:	83 fe 0a             	cmp    $0xa,%esi
80104e0d:	75 e1                	jne    80104df0 <acquire+0x50>
}
80104e0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e12:	5b                   	pop    %ebx
80104e13:	5e                   	pop    %esi
80104e14:	5d                   	pop    %ebp
80104e15:	c3                   	ret    
80104e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104e20:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104e24:	83 c3 34             	add    $0x34,%ebx
80104e27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e2e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104e30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e36:	83 c0 04             	add    $0x4,%eax
80104e39:	39 d8                	cmp    %ebx,%eax
80104e3b:	75 f3                	jne    80104e30 <acquire+0x90>
}
80104e3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e40:	5b                   	pop    %ebx
80104e41:	5e                   	pop    %esi
80104e42:	5d                   	pop    %ebp
80104e43:	c3                   	ret    
    panic("acquire");
80104e44:	83 ec 0c             	sub    $0xc,%esp
80104e47:	68 a5 81 10 80       	push   $0x801081a5
80104e4c:	e8 3f b5 ff ff       	call   80100390 <panic>
80104e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e5f:	90                   	nop

80104e60 <release>:
{
80104e60:	f3 0f 1e fb          	endbr32 
80104e64:	55                   	push   %ebp
80104e65:	89 e5                	mov    %esp,%ebp
80104e67:	53                   	push   %ebx
80104e68:	83 ec 10             	sub    $0x10,%esp
80104e6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104e6e:	53                   	push   %ebx
80104e6f:	e8 dc fe ff ff       	call   80104d50 <holding>
80104e74:	83 c4 10             	add    $0x10,%esp
80104e77:	85 c0                	test   %eax,%eax
80104e79:	74 22                	je     80104e9d <release+0x3d>
  lk->pcs[0] = 0;
80104e7b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104e82:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104e89:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104e8e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e97:	c9                   	leave  
  popcli();
80104e98:	e9 53 fe ff ff       	jmp    80104cf0 <popcli>
    panic("release");
80104e9d:	83 ec 0c             	sub    $0xc,%esp
80104ea0:	68 ad 81 10 80       	push   $0x801081ad
80104ea5:	e8 e6 b4 ff ff       	call   80100390 <panic>
80104eaa:	66 90                	xchg   %ax,%ax
80104eac:	66 90                	xchg   %ax,%ax
80104eae:	66 90                	xchg   %ax,%ax

80104eb0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104eb0:	f3 0f 1e fb          	endbr32 
80104eb4:	55                   	push   %ebp
80104eb5:	89 e5                	mov    %esp,%ebp
80104eb7:	57                   	push   %edi
80104eb8:	8b 55 08             	mov    0x8(%ebp),%edx
80104ebb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104ebe:	53                   	push   %ebx
80104ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104ec2:	89 d7                	mov    %edx,%edi
80104ec4:	09 cf                	or     %ecx,%edi
80104ec6:	83 e7 03             	and    $0x3,%edi
80104ec9:	75 25                	jne    80104ef0 <memset+0x40>
    c &= 0xFF;
80104ecb:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104ece:	c1 e0 18             	shl    $0x18,%eax
80104ed1:	89 fb                	mov    %edi,%ebx
80104ed3:	c1 e9 02             	shr    $0x2,%ecx
80104ed6:	c1 e3 10             	shl    $0x10,%ebx
80104ed9:	09 d8                	or     %ebx,%eax
80104edb:	09 f8                	or     %edi,%eax
80104edd:	c1 e7 08             	shl    $0x8,%edi
80104ee0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104ee2:	89 d7                	mov    %edx,%edi
80104ee4:	fc                   	cld    
80104ee5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104ee7:	5b                   	pop    %ebx
80104ee8:	89 d0                	mov    %edx,%eax
80104eea:	5f                   	pop    %edi
80104eeb:	5d                   	pop    %ebp
80104eec:	c3                   	ret    
80104eed:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104ef0:	89 d7                	mov    %edx,%edi
80104ef2:	fc                   	cld    
80104ef3:	f3 aa                	rep stos %al,%es:(%edi)
80104ef5:	5b                   	pop    %ebx
80104ef6:	89 d0                	mov    %edx,%eax
80104ef8:	5f                   	pop    %edi
80104ef9:	5d                   	pop    %ebp
80104efa:	c3                   	ret    
80104efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eff:	90                   	nop

80104f00 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104f00:	f3 0f 1e fb          	endbr32 
80104f04:	55                   	push   %ebp
80104f05:	89 e5                	mov    %esp,%ebp
80104f07:	56                   	push   %esi
80104f08:	8b 75 10             	mov    0x10(%ebp),%esi
80104f0b:	8b 55 08             	mov    0x8(%ebp),%edx
80104f0e:	53                   	push   %ebx
80104f0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104f12:	85 f6                	test   %esi,%esi
80104f14:	74 2a                	je     80104f40 <memcmp+0x40>
80104f16:	01 c6                	add    %eax,%esi
80104f18:	eb 10                	jmp    80104f2a <memcmp+0x2a>
80104f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104f20:	83 c0 01             	add    $0x1,%eax
80104f23:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104f26:	39 f0                	cmp    %esi,%eax
80104f28:	74 16                	je     80104f40 <memcmp+0x40>
    if(*s1 != *s2)
80104f2a:	0f b6 0a             	movzbl (%edx),%ecx
80104f2d:	0f b6 18             	movzbl (%eax),%ebx
80104f30:	38 d9                	cmp    %bl,%cl
80104f32:	74 ec                	je     80104f20 <memcmp+0x20>
      return *s1 - *s2;
80104f34:	0f b6 c1             	movzbl %cl,%eax
80104f37:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104f39:	5b                   	pop    %ebx
80104f3a:	5e                   	pop    %esi
80104f3b:	5d                   	pop    %ebp
80104f3c:	c3                   	ret    
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi
80104f40:	5b                   	pop    %ebx
  return 0;
80104f41:	31 c0                	xor    %eax,%eax
}
80104f43:	5e                   	pop    %esi
80104f44:	5d                   	pop    %ebp
80104f45:	c3                   	ret    
80104f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f4d:	8d 76 00             	lea    0x0(%esi),%esi

80104f50 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104f50:	f3 0f 1e fb          	endbr32 
80104f54:	55                   	push   %ebp
80104f55:	89 e5                	mov    %esp,%ebp
80104f57:	57                   	push   %edi
80104f58:	8b 55 08             	mov    0x8(%ebp),%edx
80104f5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f5e:	56                   	push   %esi
80104f5f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104f62:	39 d6                	cmp    %edx,%esi
80104f64:	73 2a                	jae    80104f90 <memmove+0x40>
80104f66:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104f69:	39 fa                	cmp    %edi,%edx
80104f6b:	73 23                	jae    80104f90 <memmove+0x40>
80104f6d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104f70:	85 c9                	test   %ecx,%ecx
80104f72:	74 13                	je     80104f87 <memmove+0x37>
80104f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104f78:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104f7c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104f7f:	83 e8 01             	sub    $0x1,%eax
80104f82:	83 f8 ff             	cmp    $0xffffffff,%eax
80104f85:	75 f1                	jne    80104f78 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104f87:	5e                   	pop    %esi
80104f88:	89 d0                	mov    %edx,%eax
80104f8a:	5f                   	pop    %edi
80104f8b:	5d                   	pop    %ebp
80104f8c:	c3                   	ret    
80104f8d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104f90:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104f93:	89 d7                	mov    %edx,%edi
80104f95:	85 c9                	test   %ecx,%ecx
80104f97:	74 ee                	je     80104f87 <memmove+0x37>
80104f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104fa0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104fa1:	39 f0                	cmp    %esi,%eax
80104fa3:	75 fb                	jne    80104fa0 <memmove+0x50>
}
80104fa5:	5e                   	pop    %esi
80104fa6:	89 d0                	mov    %edx,%eax
80104fa8:	5f                   	pop    %edi
80104fa9:	5d                   	pop    %ebp
80104faa:	c3                   	ret    
80104fab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104faf:	90                   	nop

80104fb0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104fb0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104fb4:	eb 9a                	jmp    80104f50 <memmove>
80104fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fbd:	8d 76 00             	lea    0x0(%esi),%esi

80104fc0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104fc0:	f3 0f 1e fb          	endbr32 
80104fc4:	55                   	push   %ebp
80104fc5:	89 e5                	mov    %esp,%ebp
80104fc7:	56                   	push   %esi
80104fc8:	8b 75 10             	mov    0x10(%ebp),%esi
80104fcb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104fce:	53                   	push   %ebx
80104fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104fd2:	85 f6                	test   %esi,%esi
80104fd4:	74 32                	je     80105008 <strncmp+0x48>
80104fd6:	01 c6                	add    %eax,%esi
80104fd8:	eb 14                	jmp    80104fee <strncmp+0x2e>
80104fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fe0:	38 da                	cmp    %bl,%dl
80104fe2:	75 14                	jne    80104ff8 <strncmp+0x38>
    n--, p++, q++;
80104fe4:	83 c0 01             	add    $0x1,%eax
80104fe7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104fea:	39 f0                	cmp    %esi,%eax
80104fec:	74 1a                	je     80105008 <strncmp+0x48>
80104fee:	0f b6 11             	movzbl (%ecx),%edx
80104ff1:	0f b6 18             	movzbl (%eax),%ebx
80104ff4:	84 d2                	test   %dl,%dl
80104ff6:	75 e8                	jne    80104fe0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104ff8:	0f b6 c2             	movzbl %dl,%eax
80104ffb:	29 d8                	sub    %ebx,%eax
}
80104ffd:	5b                   	pop    %ebx
80104ffe:	5e                   	pop    %esi
80104fff:	5d                   	pop    %ebp
80105000:	c3                   	ret    
80105001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105008:	5b                   	pop    %ebx
    return 0;
80105009:	31 c0                	xor    %eax,%eax
}
8010500b:	5e                   	pop    %esi
8010500c:	5d                   	pop    %ebp
8010500d:	c3                   	ret    
8010500e:	66 90                	xchg   %ax,%ax

80105010 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105010:	f3 0f 1e fb          	endbr32 
80105014:	55                   	push   %ebp
80105015:	89 e5                	mov    %esp,%ebp
80105017:	57                   	push   %edi
80105018:	56                   	push   %esi
80105019:	8b 75 08             	mov    0x8(%ebp),%esi
8010501c:	53                   	push   %ebx
8010501d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105020:	89 f2                	mov    %esi,%edx
80105022:	eb 1b                	jmp    8010503f <strncpy+0x2f>
80105024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105028:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010502c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010502f:	83 c2 01             	add    $0x1,%edx
80105032:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105036:	89 f9                	mov    %edi,%ecx
80105038:	88 4a ff             	mov    %cl,-0x1(%edx)
8010503b:	84 c9                	test   %cl,%cl
8010503d:	74 09                	je     80105048 <strncpy+0x38>
8010503f:	89 c3                	mov    %eax,%ebx
80105041:	83 e8 01             	sub    $0x1,%eax
80105044:	85 db                	test   %ebx,%ebx
80105046:	7f e0                	jg     80105028 <strncpy+0x18>
    ;
  while(n-- > 0)
80105048:	89 d1                	mov    %edx,%ecx
8010504a:	85 c0                	test   %eax,%eax
8010504c:	7e 15                	jle    80105063 <strncpy+0x53>
8010504e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80105050:	83 c1 01             	add    $0x1,%ecx
80105053:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80105057:	89 c8                	mov    %ecx,%eax
80105059:	f7 d0                	not    %eax
8010505b:	01 d0                	add    %edx,%eax
8010505d:	01 d8                	add    %ebx,%eax
8010505f:	85 c0                	test   %eax,%eax
80105061:	7f ed                	jg     80105050 <strncpy+0x40>
  return os;
}
80105063:	5b                   	pop    %ebx
80105064:	89 f0                	mov    %esi,%eax
80105066:	5e                   	pop    %esi
80105067:	5f                   	pop    %edi
80105068:	5d                   	pop    %ebp
80105069:	c3                   	ret    
8010506a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105070 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105070:	f3 0f 1e fb          	endbr32 
80105074:	55                   	push   %ebp
80105075:	89 e5                	mov    %esp,%ebp
80105077:	56                   	push   %esi
80105078:	8b 55 10             	mov    0x10(%ebp),%edx
8010507b:	8b 75 08             	mov    0x8(%ebp),%esi
8010507e:	53                   	push   %ebx
8010507f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105082:	85 d2                	test   %edx,%edx
80105084:	7e 21                	jle    801050a7 <safestrcpy+0x37>
80105086:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010508a:	89 f2                	mov    %esi,%edx
8010508c:	eb 12                	jmp    801050a0 <safestrcpy+0x30>
8010508e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105090:	0f b6 08             	movzbl (%eax),%ecx
80105093:	83 c0 01             	add    $0x1,%eax
80105096:	83 c2 01             	add    $0x1,%edx
80105099:	88 4a ff             	mov    %cl,-0x1(%edx)
8010509c:	84 c9                	test   %cl,%cl
8010509e:	74 04                	je     801050a4 <safestrcpy+0x34>
801050a0:	39 d8                	cmp    %ebx,%eax
801050a2:	75 ec                	jne    80105090 <safestrcpy+0x20>
    ;
  *s = 0;
801050a4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801050a7:	89 f0                	mov    %esi,%eax
801050a9:	5b                   	pop    %ebx
801050aa:	5e                   	pop    %esi
801050ab:	5d                   	pop    %ebp
801050ac:	c3                   	ret    
801050ad:	8d 76 00             	lea    0x0(%esi),%esi

801050b0 <strlen>:

int
strlen(const char *s)
{
801050b0:	f3 0f 1e fb          	endbr32 
801050b4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801050b5:	31 c0                	xor    %eax,%eax
{
801050b7:	89 e5                	mov    %esp,%ebp
801050b9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801050bc:	80 3a 00             	cmpb   $0x0,(%edx)
801050bf:	74 10                	je     801050d1 <strlen+0x21>
801050c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050c8:	83 c0 01             	add    $0x1,%eax
801050cb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801050cf:	75 f7                	jne    801050c8 <strlen+0x18>
    ;
  return n;
}
801050d1:	5d                   	pop    %ebp
801050d2:	c3                   	ret    

801050d3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801050d3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801050d7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801050db:	55                   	push   %ebp
  pushl %ebx
801050dc:	53                   	push   %ebx
  pushl %esi
801050dd:	56                   	push   %esi
  pushl %edi
801050de:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801050df:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801050e1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801050e3:	5f                   	pop    %edi
  popl %esi
801050e4:	5e                   	pop    %esi
  popl %ebx
801050e5:	5b                   	pop    %ebx
  popl %ebp
801050e6:	5d                   	pop    %ebp
  ret
801050e7:	c3                   	ret    
801050e8:	66 90                	xchg   %ax,%ax
801050ea:	66 90                	xchg   %ax,%ax
801050ec:	66 90                	xchg   %ax,%ax
801050ee:	66 90                	xchg   %ax,%ax

801050f0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801050f0:	f3 0f 1e fb          	endbr32 
801050f4:	55                   	push   %ebp
801050f5:	89 e5                	mov    %esp,%ebp
801050f7:	53                   	push   %ebx
801050f8:	83 ec 04             	sub    $0x4,%esp
801050fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801050fe:	e8 dd ed ff ff       	call   80103ee0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105103:	8b 00                	mov    (%eax),%eax
80105105:	39 d8                	cmp    %ebx,%eax
80105107:	76 17                	jbe    80105120 <fetchint+0x30>
80105109:	8d 53 04             	lea    0x4(%ebx),%edx
8010510c:	39 d0                	cmp    %edx,%eax
8010510e:	72 10                	jb     80105120 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105110:	8b 45 0c             	mov    0xc(%ebp),%eax
80105113:	8b 13                	mov    (%ebx),%edx
80105115:	89 10                	mov    %edx,(%eax)
  return 0;
80105117:	31 c0                	xor    %eax,%eax
}
80105119:	83 c4 04             	add    $0x4,%esp
8010511c:	5b                   	pop    %ebx
8010511d:	5d                   	pop    %ebp
8010511e:	c3                   	ret    
8010511f:	90                   	nop
    return -1;
80105120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105125:	eb f2                	jmp    80105119 <fetchint+0x29>
80105127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010512e:	66 90                	xchg   %ax,%ax

80105130 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105130:	f3 0f 1e fb          	endbr32 
80105134:	55                   	push   %ebp
80105135:	89 e5                	mov    %esp,%ebp
80105137:	53                   	push   %ebx
80105138:	83 ec 04             	sub    $0x4,%esp
8010513b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010513e:	e8 9d ed ff ff       	call   80103ee0 <myproc>

  if(addr >= curproc->sz)
80105143:	39 18                	cmp    %ebx,(%eax)
80105145:	76 31                	jbe    80105178 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105147:	8b 55 0c             	mov    0xc(%ebp),%edx
8010514a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010514c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010514e:	39 d3                	cmp    %edx,%ebx
80105150:	73 26                	jae    80105178 <fetchstr+0x48>
80105152:	89 d8                	mov    %ebx,%eax
80105154:	eb 11                	jmp    80105167 <fetchstr+0x37>
80105156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010515d:	8d 76 00             	lea    0x0(%esi),%esi
80105160:	83 c0 01             	add    $0x1,%eax
80105163:	39 c2                	cmp    %eax,%edx
80105165:	76 11                	jbe    80105178 <fetchstr+0x48>
    if(*s == 0)
80105167:	80 38 00             	cmpb   $0x0,(%eax)
8010516a:	75 f4                	jne    80105160 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010516c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010516f:	29 d8                	sub    %ebx,%eax
}
80105171:	5b                   	pop    %ebx
80105172:	5d                   	pop    %ebp
80105173:	c3                   	ret    
80105174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105178:	83 c4 04             	add    $0x4,%esp
    return -1;
8010517b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105180:	5b                   	pop    %ebx
80105181:	5d                   	pop    %ebp
80105182:	c3                   	ret    
80105183:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010518a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105190 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105190:	f3 0f 1e fb          	endbr32 
80105194:	55                   	push   %ebp
80105195:	89 e5                	mov    %esp,%ebp
80105197:	56                   	push   %esi
80105198:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105199:	e8 42 ed ff ff       	call   80103ee0 <myproc>
8010519e:	8b 55 08             	mov    0x8(%ebp),%edx
801051a1:	8b 40 18             	mov    0x18(%eax),%eax
801051a4:	8b 40 44             	mov    0x44(%eax),%eax
801051a7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801051aa:	e8 31 ed ff ff       	call   80103ee0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051af:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051b2:	8b 00                	mov    (%eax),%eax
801051b4:	39 c6                	cmp    %eax,%esi
801051b6:	73 18                	jae    801051d0 <argint+0x40>
801051b8:	8d 53 08             	lea    0x8(%ebx),%edx
801051bb:	39 d0                	cmp    %edx,%eax
801051bd:	72 11                	jb     801051d0 <argint+0x40>
  *ip = *(int*)(addr);
801051bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801051c2:	8b 53 04             	mov    0x4(%ebx),%edx
801051c5:	89 10                	mov    %edx,(%eax)
  return 0;
801051c7:	31 c0                	xor    %eax,%eax
}
801051c9:	5b                   	pop    %ebx
801051ca:	5e                   	pop    %esi
801051cb:	5d                   	pop    %ebp
801051cc:	c3                   	ret    
801051cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801051d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051d5:	eb f2                	jmp    801051c9 <argint+0x39>
801051d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051de:	66 90                	xchg   %ax,%ax

801051e0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801051e0:	f3 0f 1e fb          	endbr32 
801051e4:	55                   	push   %ebp
801051e5:	89 e5                	mov    %esp,%ebp
801051e7:	56                   	push   %esi
801051e8:	53                   	push   %ebx
801051e9:	83 ec 10             	sub    $0x10,%esp
801051ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801051ef:	e8 ec ec ff ff       	call   80103ee0 <myproc>
 
  if(argint(n, &i) < 0)
801051f4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801051f7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801051f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051fc:	50                   	push   %eax
801051fd:	ff 75 08             	pushl  0x8(%ebp)
80105200:	e8 8b ff ff ff       	call   80105190 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105205:	83 c4 10             	add    $0x10,%esp
80105208:	85 c0                	test   %eax,%eax
8010520a:	78 24                	js     80105230 <argptr+0x50>
8010520c:	85 db                	test   %ebx,%ebx
8010520e:	78 20                	js     80105230 <argptr+0x50>
80105210:	8b 16                	mov    (%esi),%edx
80105212:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105215:	39 c2                	cmp    %eax,%edx
80105217:	76 17                	jbe    80105230 <argptr+0x50>
80105219:	01 c3                	add    %eax,%ebx
8010521b:	39 da                	cmp    %ebx,%edx
8010521d:	72 11                	jb     80105230 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010521f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105222:	89 02                	mov    %eax,(%edx)
  return 0;
80105224:	31 c0                	xor    %eax,%eax
}
80105226:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105229:	5b                   	pop    %ebx
8010522a:	5e                   	pop    %esi
8010522b:	5d                   	pop    %ebp
8010522c:	c3                   	ret    
8010522d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105235:	eb ef                	jmp    80105226 <argptr+0x46>
80105237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010523e:	66 90                	xchg   %ax,%ax

80105240 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105240:	f3 0f 1e fb          	endbr32 
80105244:	55                   	push   %ebp
80105245:	89 e5                	mov    %esp,%ebp
80105247:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010524a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010524d:	50                   	push   %eax
8010524e:	ff 75 08             	pushl  0x8(%ebp)
80105251:	e8 3a ff ff ff       	call   80105190 <argint>
80105256:	83 c4 10             	add    $0x10,%esp
80105259:	85 c0                	test   %eax,%eax
8010525b:	78 13                	js     80105270 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010525d:	83 ec 08             	sub    $0x8,%esp
80105260:	ff 75 0c             	pushl  0xc(%ebp)
80105263:	ff 75 f4             	pushl  -0xc(%ebp)
80105266:	e8 c5 fe ff ff       	call   80105130 <fetchstr>
8010526b:	83 c4 10             	add    $0x10,%esp
}
8010526e:	c9                   	leave  
8010526f:	c3                   	ret    
80105270:	c9                   	leave  
    return -1;
80105271:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105276:	c3                   	ret    
80105277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010527e:	66 90                	xchg   %ax,%ax

80105280 <syscall>:
[SYS_multiple_acquire] sys_multiple_acquire,
};

void
syscall(void)
{
80105280:	f3 0f 1e fb          	endbr32 
80105284:	55                   	push   %ebp
80105285:	89 e5                	mov    %esp,%ebp
80105287:	53                   	push   %ebx
80105288:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010528b:	e8 50 ec ff ff       	call   80103ee0 <myproc>
80105290:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105292:	8b 40 18             	mov    0x18(%eax),%eax
80105295:	8b 40 1c             	mov    0x1c(%eax),%eax

  curproc->sys_call_count[num]++;       // count system calls for each process

  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105298:	8d 50 ff             	lea    -0x1(%eax),%edx
  curproc->sys_call_count[num]++;       // count system calls for each process
8010529b:	83 44 83 7c 01       	addl   $0x1,0x7c(%ebx,%eax,4)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801052a0:	83 fa 1c             	cmp    $0x1c,%edx
801052a3:	77 1b                	ja     801052c0 <syscall+0x40>
801052a5:	8b 14 85 e0 81 10 80 	mov    -0x7fef7e20(,%eax,4),%edx
801052ac:	85 d2                	test   %edx,%edx
801052ae:	74 10                	je     801052c0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801052b0:	ff d2                	call   *%edx
801052b2:	89 c2                	mov    %eax,%edx
801052b4:	8b 43 18             	mov    0x18(%ebx),%eax
801052b7:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801052ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052bd:	c9                   	leave  
801052be:	c3                   	ret    
801052bf:	90                   	nop
    cprintf("%d %s: unknown sys call %d\n",
801052c0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801052c1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801052c4:	50                   	push   %eax
801052c5:	ff 73 10             	pushl  0x10(%ebx)
801052c8:	68 b5 81 10 80       	push   $0x801081b5
801052cd:	e8 de b3 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801052d2:	8b 43 18             	mov    0x18(%ebx),%eax
801052d5:	83 c4 10             	add    $0x10,%esp
801052d8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801052df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052e2:	c9                   	leave  
801052e3:	c3                   	ret    
801052e4:	66 90                	xchg   %ax,%ax
801052e6:	66 90                	xchg   %ax,%ax
801052e8:	66 90                	xchg   %ax,%ax
801052ea:	66 90                	xchg   %ax,%ax
801052ec:	66 90                	xchg   %ax,%ax
801052ee:	66 90                	xchg   %ax,%ax

801052f0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	57                   	push   %edi
801052f4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801052f5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801052f8:	53                   	push   %ebx
801052f9:	83 ec 34             	sub    $0x34,%esp
801052fc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801052ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105302:	57                   	push   %edi
80105303:	50                   	push   %eax
{
80105304:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105307:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010530a:	e8 91 d2 ff ff       	call   801025a0 <nameiparent>
8010530f:	83 c4 10             	add    $0x10,%esp
80105312:	85 c0                	test   %eax,%eax
80105314:	0f 84 46 01 00 00    	je     80105460 <create+0x170>
    return 0;
  ilock(dp);
8010531a:	83 ec 0c             	sub    $0xc,%esp
8010531d:	89 c3                	mov    %eax,%ebx
8010531f:	50                   	push   %eax
80105320:	e8 8b c9 ff ff       	call   80101cb0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105325:	83 c4 0c             	add    $0xc,%esp
80105328:	6a 00                	push   $0x0
8010532a:	57                   	push   %edi
8010532b:	53                   	push   %ebx
8010532c:	e8 cf ce ff ff       	call   80102200 <dirlookup>
80105331:	83 c4 10             	add    $0x10,%esp
80105334:	89 c6                	mov    %eax,%esi
80105336:	85 c0                	test   %eax,%eax
80105338:	74 56                	je     80105390 <create+0xa0>
    iunlockput(dp);
8010533a:	83 ec 0c             	sub    $0xc,%esp
8010533d:	53                   	push   %ebx
8010533e:	e8 0d cc ff ff       	call   80101f50 <iunlockput>
    ilock(ip);
80105343:	89 34 24             	mov    %esi,(%esp)
80105346:	e8 65 c9 ff ff       	call   80101cb0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010534b:	83 c4 10             	add    $0x10,%esp
8010534e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105353:	75 1b                	jne    80105370 <create+0x80>
80105355:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010535a:	75 14                	jne    80105370 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010535c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010535f:	89 f0                	mov    %esi,%eax
80105361:	5b                   	pop    %ebx
80105362:	5e                   	pop    %esi
80105363:	5f                   	pop    %edi
80105364:	5d                   	pop    %ebp
80105365:	c3                   	ret    
80105366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010536d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105370:	83 ec 0c             	sub    $0xc,%esp
80105373:	56                   	push   %esi
    return 0;
80105374:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105376:	e8 d5 cb ff ff       	call   80101f50 <iunlockput>
    return 0;
8010537b:	83 c4 10             	add    $0x10,%esp
}
8010537e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105381:	89 f0                	mov    %esi,%eax
80105383:	5b                   	pop    %ebx
80105384:	5e                   	pop    %esi
80105385:	5f                   	pop    %edi
80105386:	5d                   	pop    %ebp
80105387:	c3                   	ret    
80105388:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105390:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105394:	83 ec 08             	sub    $0x8,%esp
80105397:	50                   	push   %eax
80105398:	ff 33                	pushl  (%ebx)
8010539a:	e8 91 c7 ff ff       	call   80101b30 <ialloc>
8010539f:	83 c4 10             	add    $0x10,%esp
801053a2:	89 c6                	mov    %eax,%esi
801053a4:	85 c0                	test   %eax,%eax
801053a6:	0f 84 cd 00 00 00    	je     80105479 <create+0x189>
  ilock(ip);
801053ac:	83 ec 0c             	sub    $0xc,%esp
801053af:	50                   	push   %eax
801053b0:	e8 fb c8 ff ff       	call   80101cb0 <ilock>
  ip->major = major;
801053b5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801053b9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801053bd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801053c1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801053c5:	b8 01 00 00 00       	mov    $0x1,%eax
801053ca:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801053ce:	89 34 24             	mov    %esi,(%esp)
801053d1:	e8 1a c8 ff ff       	call   80101bf0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801053d6:	83 c4 10             	add    $0x10,%esp
801053d9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801053de:	74 30                	je     80105410 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801053e0:	83 ec 04             	sub    $0x4,%esp
801053e3:	ff 76 04             	pushl  0x4(%esi)
801053e6:	57                   	push   %edi
801053e7:	53                   	push   %ebx
801053e8:	e8 d3 d0 ff ff       	call   801024c0 <dirlink>
801053ed:	83 c4 10             	add    $0x10,%esp
801053f0:	85 c0                	test   %eax,%eax
801053f2:	78 78                	js     8010546c <create+0x17c>
  iunlockput(dp);
801053f4:	83 ec 0c             	sub    $0xc,%esp
801053f7:	53                   	push   %ebx
801053f8:	e8 53 cb ff ff       	call   80101f50 <iunlockput>
  return ip;
801053fd:	83 c4 10             	add    $0x10,%esp
}
80105400:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105403:	89 f0                	mov    %esi,%eax
80105405:	5b                   	pop    %ebx
80105406:	5e                   	pop    %esi
80105407:	5f                   	pop    %edi
80105408:	5d                   	pop    %ebp
80105409:	c3                   	ret    
8010540a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105410:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105413:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105418:	53                   	push   %ebx
80105419:	e8 d2 c7 ff ff       	call   80101bf0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010541e:	83 c4 0c             	add    $0xc,%esp
80105421:	ff 76 04             	pushl  0x4(%esi)
80105424:	68 74 82 10 80       	push   $0x80108274
80105429:	56                   	push   %esi
8010542a:	e8 91 d0 ff ff       	call   801024c0 <dirlink>
8010542f:	83 c4 10             	add    $0x10,%esp
80105432:	85 c0                	test   %eax,%eax
80105434:	78 18                	js     8010544e <create+0x15e>
80105436:	83 ec 04             	sub    $0x4,%esp
80105439:	ff 73 04             	pushl  0x4(%ebx)
8010543c:	68 73 82 10 80       	push   $0x80108273
80105441:	56                   	push   %esi
80105442:	e8 79 d0 ff ff       	call   801024c0 <dirlink>
80105447:	83 c4 10             	add    $0x10,%esp
8010544a:	85 c0                	test   %eax,%eax
8010544c:	79 92                	jns    801053e0 <create+0xf0>
      panic("create dots");
8010544e:	83 ec 0c             	sub    $0xc,%esp
80105451:	68 67 82 10 80       	push   $0x80108267
80105456:	e8 35 af ff ff       	call   80100390 <panic>
8010545b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010545f:	90                   	nop
}
80105460:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105463:	31 f6                	xor    %esi,%esi
}
80105465:	5b                   	pop    %ebx
80105466:	89 f0                	mov    %esi,%eax
80105468:	5e                   	pop    %esi
80105469:	5f                   	pop    %edi
8010546a:	5d                   	pop    %ebp
8010546b:	c3                   	ret    
    panic("create: dirlink");
8010546c:	83 ec 0c             	sub    $0xc,%esp
8010546f:	68 76 82 10 80       	push   $0x80108276
80105474:	e8 17 af ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105479:	83 ec 0c             	sub    $0xc,%esp
8010547c:	68 58 82 10 80       	push   $0x80108258
80105481:	e8 0a af ff ff       	call   80100390 <panic>
80105486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010548d:	8d 76 00             	lea    0x0(%esi),%esi

80105490 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	56                   	push   %esi
80105494:	89 d6                	mov    %edx,%esi
80105496:	53                   	push   %ebx
80105497:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105499:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010549c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010549f:	50                   	push   %eax
801054a0:	6a 00                	push   $0x0
801054a2:	e8 e9 fc ff ff       	call   80105190 <argint>
801054a7:	83 c4 10             	add    $0x10,%esp
801054aa:	85 c0                	test   %eax,%eax
801054ac:	78 2a                	js     801054d8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801054ae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054b2:	77 24                	ja     801054d8 <argfd.constprop.0+0x48>
801054b4:	e8 27 ea ff ff       	call   80103ee0 <myproc>
801054b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054bc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801054c0:	85 c0                	test   %eax,%eax
801054c2:	74 14                	je     801054d8 <argfd.constprop.0+0x48>
  if(pfd)
801054c4:	85 db                	test   %ebx,%ebx
801054c6:	74 02                	je     801054ca <argfd.constprop.0+0x3a>
    *pfd = fd;
801054c8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801054ca:	89 06                	mov    %eax,(%esi)
  return 0;
801054cc:	31 c0                	xor    %eax,%eax
}
801054ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054d1:	5b                   	pop    %ebx
801054d2:	5e                   	pop    %esi
801054d3:	5d                   	pop    %ebp
801054d4:	c3                   	ret    
801054d5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801054d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054dd:	eb ef                	jmp    801054ce <argfd.constprop.0+0x3e>
801054df:	90                   	nop

801054e0 <sys_dup>:
{
801054e0:	f3 0f 1e fb          	endbr32 
801054e4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801054e5:	31 c0                	xor    %eax,%eax
{
801054e7:	89 e5                	mov    %esp,%ebp
801054e9:	56                   	push   %esi
801054ea:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801054eb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801054ee:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801054f1:	e8 9a ff ff ff       	call   80105490 <argfd.constprop.0>
801054f6:	85 c0                	test   %eax,%eax
801054f8:	78 1e                	js     80105518 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
801054fa:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801054fd:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801054ff:	e8 dc e9 ff ff       	call   80103ee0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105508:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010550c:	85 d2                	test   %edx,%edx
8010550e:	74 20                	je     80105530 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105510:	83 c3 01             	add    $0x1,%ebx
80105513:	83 fb 10             	cmp    $0x10,%ebx
80105516:	75 f0                	jne    80105508 <sys_dup+0x28>
}
80105518:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010551b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105520:	89 d8                	mov    %ebx,%eax
80105522:	5b                   	pop    %ebx
80105523:	5e                   	pop    %esi
80105524:	5d                   	pop    %ebp
80105525:	c3                   	ret    
80105526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105530:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105534:	83 ec 0c             	sub    $0xc,%esp
80105537:	ff 75 f4             	pushl  -0xc(%ebp)
8010553a:	e8 81 be ff ff       	call   801013c0 <filedup>
  return fd;
8010553f:	83 c4 10             	add    $0x10,%esp
}
80105542:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105545:	89 d8                	mov    %ebx,%eax
80105547:	5b                   	pop    %ebx
80105548:	5e                   	pop    %esi
80105549:	5d                   	pop    %ebp
8010554a:	c3                   	ret    
8010554b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010554f:	90                   	nop

80105550 <sys_read>:
{
80105550:	f3 0f 1e fb          	endbr32 
80105554:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105555:	31 c0                	xor    %eax,%eax
{
80105557:	89 e5                	mov    %esp,%ebp
80105559:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010555c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010555f:	e8 2c ff ff ff       	call   80105490 <argfd.constprop.0>
80105564:	85 c0                	test   %eax,%eax
80105566:	78 48                	js     801055b0 <sys_read+0x60>
80105568:	83 ec 08             	sub    $0x8,%esp
8010556b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010556e:	50                   	push   %eax
8010556f:	6a 02                	push   $0x2
80105571:	e8 1a fc ff ff       	call   80105190 <argint>
80105576:	83 c4 10             	add    $0x10,%esp
80105579:	85 c0                	test   %eax,%eax
8010557b:	78 33                	js     801055b0 <sys_read+0x60>
8010557d:	83 ec 04             	sub    $0x4,%esp
80105580:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105583:	ff 75 f0             	pushl  -0x10(%ebp)
80105586:	50                   	push   %eax
80105587:	6a 01                	push   $0x1
80105589:	e8 52 fc ff ff       	call   801051e0 <argptr>
8010558e:	83 c4 10             	add    $0x10,%esp
80105591:	85 c0                	test   %eax,%eax
80105593:	78 1b                	js     801055b0 <sys_read+0x60>
  return fileread(f, p, n);
80105595:	83 ec 04             	sub    $0x4,%esp
80105598:	ff 75 f0             	pushl  -0x10(%ebp)
8010559b:	ff 75 f4             	pushl  -0xc(%ebp)
8010559e:	ff 75 ec             	pushl  -0x14(%ebp)
801055a1:	e8 9a bf ff ff       	call   80101540 <fileread>
801055a6:	83 c4 10             	add    $0x10,%esp
}
801055a9:	c9                   	leave  
801055aa:	c3                   	ret    
801055ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055af:	90                   	nop
801055b0:	c9                   	leave  
    return -1;
801055b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055b6:	c3                   	ret    
801055b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055be:	66 90                	xchg   %ax,%ax

801055c0 <sys_write>:
{
801055c0:	f3 0f 1e fb          	endbr32 
801055c4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055c5:	31 c0                	xor    %eax,%eax
{
801055c7:	89 e5                	mov    %esp,%ebp
801055c9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055cc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801055cf:	e8 bc fe ff ff       	call   80105490 <argfd.constprop.0>
801055d4:	85 c0                	test   %eax,%eax
801055d6:	78 48                	js     80105620 <sys_write+0x60>
801055d8:	83 ec 08             	sub    $0x8,%esp
801055db:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055de:	50                   	push   %eax
801055df:	6a 02                	push   $0x2
801055e1:	e8 aa fb ff ff       	call   80105190 <argint>
801055e6:	83 c4 10             	add    $0x10,%esp
801055e9:	85 c0                	test   %eax,%eax
801055eb:	78 33                	js     80105620 <sys_write+0x60>
801055ed:	83 ec 04             	sub    $0x4,%esp
801055f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055f3:	ff 75 f0             	pushl  -0x10(%ebp)
801055f6:	50                   	push   %eax
801055f7:	6a 01                	push   $0x1
801055f9:	e8 e2 fb ff ff       	call   801051e0 <argptr>
801055fe:	83 c4 10             	add    $0x10,%esp
80105601:	85 c0                	test   %eax,%eax
80105603:	78 1b                	js     80105620 <sys_write+0x60>
  return filewrite(f, p, n);
80105605:	83 ec 04             	sub    $0x4,%esp
80105608:	ff 75 f0             	pushl  -0x10(%ebp)
8010560b:	ff 75 f4             	pushl  -0xc(%ebp)
8010560e:	ff 75 ec             	pushl  -0x14(%ebp)
80105611:	e8 ca bf ff ff       	call   801015e0 <filewrite>
80105616:	83 c4 10             	add    $0x10,%esp
}
80105619:	c9                   	leave  
8010561a:	c3                   	ret    
8010561b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010561f:	90                   	nop
80105620:	c9                   	leave  
    return -1;
80105621:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105626:	c3                   	ret    
80105627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010562e:	66 90                	xchg   %ax,%ax

80105630 <sys_close>:
{
80105630:	f3 0f 1e fb          	endbr32 
80105634:	55                   	push   %ebp
80105635:	89 e5                	mov    %esp,%ebp
80105637:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010563a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010563d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105640:	e8 4b fe ff ff       	call   80105490 <argfd.constprop.0>
80105645:	85 c0                	test   %eax,%eax
80105647:	78 27                	js     80105670 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105649:	e8 92 e8 ff ff       	call   80103ee0 <myproc>
8010564e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105651:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105654:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010565b:	00 
  fileclose(f);
8010565c:	ff 75 f4             	pushl  -0xc(%ebp)
8010565f:	e8 ac bd ff ff       	call   80101410 <fileclose>
  return 0;
80105664:	83 c4 10             	add    $0x10,%esp
80105667:	31 c0                	xor    %eax,%eax
}
80105669:	c9                   	leave  
8010566a:	c3                   	ret    
8010566b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010566f:	90                   	nop
80105670:	c9                   	leave  
    return -1;
80105671:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105676:	c3                   	ret    
80105677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010567e:	66 90                	xchg   %ax,%ax

80105680 <sys_fstat>:
{
80105680:	f3 0f 1e fb          	endbr32 
80105684:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105685:	31 c0                	xor    %eax,%eax
{
80105687:	89 e5                	mov    %esp,%ebp
80105689:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010568c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010568f:	e8 fc fd ff ff       	call   80105490 <argfd.constprop.0>
80105694:	85 c0                	test   %eax,%eax
80105696:	78 30                	js     801056c8 <sys_fstat+0x48>
80105698:	83 ec 04             	sub    $0x4,%esp
8010569b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010569e:	6a 14                	push   $0x14
801056a0:	50                   	push   %eax
801056a1:	6a 01                	push   $0x1
801056a3:	e8 38 fb ff ff       	call   801051e0 <argptr>
801056a8:	83 c4 10             	add    $0x10,%esp
801056ab:	85 c0                	test   %eax,%eax
801056ad:	78 19                	js     801056c8 <sys_fstat+0x48>
  return filestat(f, st);
801056af:	83 ec 08             	sub    $0x8,%esp
801056b2:	ff 75 f4             	pushl  -0xc(%ebp)
801056b5:	ff 75 f0             	pushl  -0x10(%ebp)
801056b8:	e8 33 be ff ff       	call   801014f0 <filestat>
801056bd:	83 c4 10             	add    $0x10,%esp
}
801056c0:	c9                   	leave  
801056c1:	c3                   	ret    
801056c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801056c8:	c9                   	leave  
    return -1;
801056c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056ce:	c3                   	ret    
801056cf:	90                   	nop

801056d0 <sys_link>:
{
801056d0:	f3 0f 1e fb          	endbr32 
801056d4:	55                   	push   %ebp
801056d5:	89 e5                	mov    %esp,%ebp
801056d7:	57                   	push   %edi
801056d8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056d9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801056dc:	53                   	push   %ebx
801056dd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056e0:	50                   	push   %eax
801056e1:	6a 00                	push   $0x0
801056e3:	e8 58 fb ff ff       	call   80105240 <argstr>
801056e8:	83 c4 10             	add    $0x10,%esp
801056eb:	85 c0                	test   %eax,%eax
801056ed:	0f 88 ff 00 00 00    	js     801057f2 <sys_link+0x122>
801056f3:	83 ec 08             	sub    $0x8,%esp
801056f6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801056f9:	50                   	push   %eax
801056fa:	6a 01                	push   $0x1
801056fc:	e8 3f fb ff ff       	call   80105240 <argstr>
80105701:	83 c4 10             	add    $0x10,%esp
80105704:	85 c0                	test   %eax,%eax
80105706:	0f 88 e6 00 00 00    	js     801057f2 <sys_link+0x122>
  begin_op();
8010570c:	e8 6f db ff ff       	call   80103280 <begin_op>
  if((ip = namei(old)) == 0){
80105711:	83 ec 0c             	sub    $0xc,%esp
80105714:	ff 75 d4             	pushl  -0x2c(%ebp)
80105717:	e8 64 ce ff ff       	call   80102580 <namei>
8010571c:	83 c4 10             	add    $0x10,%esp
8010571f:	89 c3                	mov    %eax,%ebx
80105721:	85 c0                	test   %eax,%eax
80105723:	0f 84 e8 00 00 00    	je     80105811 <sys_link+0x141>
  ilock(ip);
80105729:	83 ec 0c             	sub    $0xc,%esp
8010572c:	50                   	push   %eax
8010572d:	e8 7e c5 ff ff       	call   80101cb0 <ilock>
  if(ip->type == T_DIR){
80105732:	83 c4 10             	add    $0x10,%esp
80105735:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010573a:	0f 84 b9 00 00 00    	je     801057f9 <sys_link+0x129>
  iupdate(ip);
80105740:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105743:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105748:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010574b:	53                   	push   %ebx
8010574c:	e8 9f c4 ff ff       	call   80101bf0 <iupdate>
  iunlock(ip);
80105751:	89 1c 24             	mov    %ebx,(%esp)
80105754:	e8 37 c6 ff ff       	call   80101d90 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105759:	58                   	pop    %eax
8010575a:	5a                   	pop    %edx
8010575b:	57                   	push   %edi
8010575c:	ff 75 d0             	pushl  -0x30(%ebp)
8010575f:	e8 3c ce ff ff       	call   801025a0 <nameiparent>
80105764:	83 c4 10             	add    $0x10,%esp
80105767:	89 c6                	mov    %eax,%esi
80105769:	85 c0                	test   %eax,%eax
8010576b:	74 5f                	je     801057cc <sys_link+0xfc>
  ilock(dp);
8010576d:	83 ec 0c             	sub    $0xc,%esp
80105770:	50                   	push   %eax
80105771:	e8 3a c5 ff ff       	call   80101cb0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105776:	8b 03                	mov    (%ebx),%eax
80105778:	83 c4 10             	add    $0x10,%esp
8010577b:	39 06                	cmp    %eax,(%esi)
8010577d:	75 41                	jne    801057c0 <sys_link+0xf0>
8010577f:	83 ec 04             	sub    $0x4,%esp
80105782:	ff 73 04             	pushl  0x4(%ebx)
80105785:	57                   	push   %edi
80105786:	56                   	push   %esi
80105787:	e8 34 cd ff ff       	call   801024c0 <dirlink>
8010578c:	83 c4 10             	add    $0x10,%esp
8010578f:	85 c0                	test   %eax,%eax
80105791:	78 2d                	js     801057c0 <sys_link+0xf0>
  iunlockput(dp);
80105793:	83 ec 0c             	sub    $0xc,%esp
80105796:	56                   	push   %esi
80105797:	e8 b4 c7 ff ff       	call   80101f50 <iunlockput>
  iput(ip);
8010579c:	89 1c 24             	mov    %ebx,(%esp)
8010579f:	e8 3c c6 ff ff       	call   80101de0 <iput>
  end_op();
801057a4:	e8 47 db ff ff       	call   801032f0 <end_op>
  return 0;
801057a9:	83 c4 10             	add    $0x10,%esp
801057ac:	31 c0                	xor    %eax,%eax
}
801057ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057b1:	5b                   	pop    %ebx
801057b2:	5e                   	pop    %esi
801057b3:	5f                   	pop    %edi
801057b4:	5d                   	pop    %ebp
801057b5:	c3                   	ret    
801057b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057bd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801057c0:	83 ec 0c             	sub    $0xc,%esp
801057c3:	56                   	push   %esi
801057c4:	e8 87 c7 ff ff       	call   80101f50 <iunlockput>
    goto bad;
801057c9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801057cc:	83 ec 0c             	sub    $0xc,%esp
801057cf:	53                   	push   %ebx
801057d0:	e8 db c4 ff ff       	call   80101cb0 <ilock>
  ip->nlink--;
801057d5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057da:	89 1c 24             	mov    %ebx,(%esp)
801057dd:	e8 0e c4 ff ff       	call   80101bf0 <iupdate>
  iunlockput(ip);
801057e2:	89 1c 24             	mov    %ebx,(%esp)
801057e5:	e8 66 c7 ff ff       	call   80101f50 <iunlockput>
  end_op();
801057ea:	e8 01 db ff ff       	call   801032f0 <end_op>
  return -1;
801057ef:	83 c4 10             	add    $0x10,%esp
801057f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057f7:	eb b5                	jmp    801057ae <sys_link+0xde>
    iunlockput(ip);
801057f9:	83 ec 0c             	sub    $0xc,%esp
801057fc:	53                   	push   %ebx
801057fd:	e8 4e c7 ff ff       	call   80101f50 <iunlockput>
    end_op();
80105802:	e8 e9 da ff ff       	call   801032f0 <end_op>
    return -1;
80105807:	83 c4 10             	add    $0x10,%esp
8010580a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010580f:	eb 9d                	jmp    801057ae <sys_link+0xde>
    end_op();
80105811:	e8 da da ff ff       	call   801032f0 <end_op>
    return -1;
80105816:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010581b:	eb 91                	jmp    801057ae <sys_link+0xde>
8010581d:	8d 76 00             	lea    0x0(%esi),%esi

80105820 <sys_unlink>:
{
80105820:	f3 0f 1e fb          	endbr32 
80105824:	55                   	push   %ebp
80105825:	89 e5                	mov    %esp,%ebp
80105827:	57                   	push   %edi
80105828:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105829:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010582c:	53                   	push   %ebx
8010582d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105830:	50                   	push   %eax
80105831:	6a 00                	push   $0x0
80105833:	e8 08 fa ff ff       	call   80105240 <argstr>
80105838:	83 c4 10             	add    $0x10,%esp
8010583b:	85 c0                	test   %eax,%eax
8010583d:	0f 88 7d 01 00 00    	js     801059c0 <sys_unlink+0x1a0>
  begin_op();
80105843:	e8 38 da ff ff       	call   80103280 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105848:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010584b:	83 ec 08             	sub    $0x8,%esp
8010584e:	53                   	push   %ebx
8010584f:	ff 75 c0             	pushl  -0x40(%ebp)
80105852:	e8 49 cd ff ff       	call   801025a0 <nameiparent>
80105857:	83 c4 10             	add    $0x10,%esp
8010585a:	89 c6                	mov    %eax,%esi
8010585c:	85 c0                	test   %eax,%eax
8010585e:	0f 84 66 01 00 00    	je     801059ca <sys_unlink+0x1aa>
  ilock(dp);
80105864:	83 ec 0c             	sub    $0xc,%esp
80105867:	50                   	push   %eax
80105868:	e8 43 c4 ff ff       	call   80101cb0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010586d:	58                   	pop    %eax
8010586e:	5a                   	pop    %edx
8010586f:	68 74 82 10 80       	push   $0x80108274
80105874:	53                   	push   %ebx
80105875:	e8 66 c9 ff ff       	call   801021e0 <namecmp>
8010587a:	83 c4 10             	add    $0x10,%esp
8010587d:	85 c0                	test   %eax,%eax
8010587f:	0f 84 03 01 00 00    	je     80105988 <sys_unlink+0x168>
80105885:	83 ec 08             	sub    $0x8,%esp
80105888:	68 73 82 10 80       	push   $0x80108273
8010588d:	53                   	push   %ebx
8010588e:	e8 4d c9 ff ff       	call   801021e0 <namecmp>
80105893:	83 c4 10             	add    $0x10,%esp
80105896:	85 c0                	test   %eax,%eax
80105898:	0f 84 ea 00 00 00    	je     80105988 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010589e:	83 ec 04             	sub    $0x4,%esp
801058a1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801058a4:	50                   	push   %eax
801058a5:	53                   	push   %ebx
801058a6:	56                   	push   %esi
801058a7:	e8 54 c9 ff ff       	call   80102200 <dirlookup>
801058ac:	83 c4 10             	add    $0x10,%esp
801058af:	89 c3                	mov    %eax,%ebx
801058b1:	85 c0                	test   %eax,%eax
801058b3:	0f 84 cf 00 00 00    	je     80105988 <sys_unlink+0x168>
  ilock(ip);
801058b9:	83 ec 0c             	sub    $0xc,%esp
801058bc:	50                   	push   %eax
801058bd:	e8 ee c3 ff ff       	call   80101cb0 <ilock>
  if(ip->nlink < 1)
801058c2:	83 c4 10             	add    $0x10,%esp
801058c5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801058ca:	0f 8e 23 01 00 00    	jle    801059f3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801058d0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058d5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801058d8:	74 66                	je     80105940 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801058da:	83 ec 04             	sub    $0x4,%esp
801058dd:	6a 10                	push   $0x10
801058df:	6a 00                	push   $0x0
801058e1:	57                   	push   %edi
801058e2:	e8 c9 f5 ff ff       	call   80104eb0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801058e7:	6a 10                	push   $0x10
801058e9:	ff 75 c4             	pushl  -0x3c(%ebp)
801058ec:	57                   	push   %edi
801058ed:	56                   	push   %esi
801058ee:	e8 bd c7 ff ff       	call   801020b0 <writei>
801058f3:	83 c4 20             	add    $0x20,%esp
801058f6:	83 f8 10             	cmp    $0x10,%eax
801058f9:	0f 85 e7 00 00 00    	jne    801059e6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
801058ff:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105904:	0f 84 96 00 00 00    	je     801059a0 <sys_unlink+0x180>
  iunlockput(dp);
8010590a:	83 ec 0c             	sub    $0xc,%esp
8010590d:	56                   	push   %esi
8010590e:	e8 3d c6 ff ff       	call   80101f50 <iunlockput>
  ip->nlink--;
80105913:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105918:	89 1c 24             	mov    %ebx,(%esp)
8010591b:	e8 d0 c2 ff ff       	call   80101bf0 <iupdate>
  iunlockput(ip);
80105920:	89 1c 24             	mov    %ebx,(%esp)
80105923:	e8 28 c6 ff ff       	call   80101f50 <iunlockput>
  end_op();
80105928:	e8 c3 d9 ff ff       	call   801032f0 <end_op>
  return 0;
8010592d:	83 c4 10             	add    $0x10,%esp
80105930:	31 c0                	xor    %eax,%eax
}
80105932:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105935:	5b                   	pop    %ebx
80105936:	5e                   	pop    %esi
80105937:	5f                   	pop    %edi
80105938:	5d                   	pop    %ebp
80105939:	c3                   	ret    
8010593a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105940:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105944:	76 94                	jbe    801058da <sys_unlink+0xba>
80105946:	ba 20 00 00 00       	mov    $0x20,%edx
8010594b:	eb 0b                	jmp    80105958 <sys_unlink+0x138>
8010594d:	8d 76 00             	lea    0x0(%esi),%esi
80105950:	83 c2 10             	add    $0x10,%edx
80105953:	39 53 58             	cmp    %edx,0x58(%ebx)
80105956:	76 82                	jbe    801058da <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105958:	6a 10                	push   $0x10
8010595a:	52                   	push   %edx
8010595b:	57                   	push   %edi
8010595c:	53                   	push   %ebx
8010595d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105960:	e8 4b c6 ff ff       	call   80101fb0 <readi>
80105965:	83 c4 10             	add    $0x10,%esp
80105968:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010596b:	83 f8 10             	cmp    $0x10,%eax
8010596e:	75 69                	jne    801059d9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105970:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105975:	74 d9                	je     80105950 <sys_unlink+0x130>
    iunlockput(ip);
80105977:	83 ec 0c             	sub    $0xc,%esp
8010597a:	53                   	push   %ebx
8010597b:	e8 d0 c5 ff ff       	call   80101f50 <iunlockput>
    goto bad;
80105980:	83 c4 10             	add    $0x10,%esp
80105983:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105987:	90                   	nop
  iunlockput(dp);
80105988:	83 ec 0c             	sub    $0xc,%esp
8010598b:	56                   	push   %esi
8010598c:	e8 bf c5 ff ff       	call   80101f50 <iunlockput>
  end_op();
80105991:	e8 5a d9 ff ff       	call   801032f0 <end_op>
  return -1;
80105996:	83 c4 10             	add    $0x10,%esp
80105999:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010599e:	eb 92                	jmp    80105932 <sys_unlink+0x112>
    iupdate(dp);
801059a0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801059a3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801059a8:	56                   	push   %esi
801059a9:	e8 42 c2 ff ff       	call   80101bf0 <iupdate>
801059ae:	83 c4 10             	add    $0x10,%esp
801059b1:	e9 54 ff ff ff       	jmp    8010590a <sys_unlink+0xea>
801059b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801059c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c5:	e9 68 ff ff ff       	jmp    80105932 <sys_unlink+0x112>
    end_op();
801059ca:	e8 21 d9 ff ff       	call   801032f0 <end_op>
    return -1;
801059cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059d4:	e9 59 ff ff ff       	jmp    80105932 <sys_unlink+0x112>
      panic("isdirempty: readi");
801059d9:	83 ec 0c             	sub    $0xc,%esp
801059dc:	68 98 82 10 80       	push   $0x80108298
801059e1:	e8 aa a9 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801059e6:	83 ec 0c             	sub    $0xc,%esp
801059e9:	68 aa 82 10 80       	push   $0x801082aa
801059ee:	e8 9d a9 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801059f3:	83 ec 0c             	sub    $0xc,%esp
801059f6:	68 86 82 10 80       	push   $0x80108286
801059fb:	e8 90 a9 ff ff       	call   80100390 <panic>

80105a00 <sys_open>:

int
sys_open(void)
{
80105a00:	f3 0f 1e fb          	endbr32 
80105a04:	55                   	push   %ebp
80105a05:	89 e5                	mov    %esp,%ebp
80105a07:	57                   	push   %edi
80105a08:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a09:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105a0c:	53                   	push   %ebx
80105a0d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a10:	50                   	push   %eax
80105a11:	6a 00                	push   $0x0
80105a13:	e8 28 f8 ff ff       	call   80105240 <argstr>
80105a18:	83 c4 10             	add    $0x10,%esp
80105a1b:	85 c0                	test   %eax,%eax
80105a1d:	0f 88 8a 00 00 00    	js     80105aad <sys_open+0xad>
80105a23:	83 ec 08             	sub    $0x8,%esp
80105a26:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a29:	50                   	push   %eax
80105a2a:	6a 01                	push   $0x1
80105a2c:	e8 5f f7 ff ff       	call   80105190 <argint>
80105a31:	83 c4 10             	add    $0x10,%esp
80105a34:	85 c0                	test   %eax,%eax
80105a36:	78 75                	js     80105aad <sys_open+0xad>
    return -1;

  begin_op();
80105a38:	e8 43 d8 ff ff       	call   80103280 <begin_op>

  if(omode & O_CREATE){
80105a3d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105a41:	75 75                	jne    80105ab8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105a43:	83 ec 0c             	sub    $0xc,%esp
80105a46:	ff 75 e0             	pushl  -0x20(%ebp)
80105a49:	e8 32 cb ff ff       	call   80102580 <namei>
80105a4e:	83 c4 10             	add    $0x10,%esp
80105a51:	89 c6                	mov    %eax,%esi
80105a53:	85 c0                	test   %eax,%eax
80105a55:	74 7e                	je     80105ad5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105a57:	83 ec 0c             	sub    $0xc,%esp
80105a5a:	50                   	push   %eax
80105a5b:	e8 50 c2 ff ff       	call   80101cb0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a60:	83 c4 10             	add    $0x10,%esp
80105a63:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105a68:	0f 84 c2 00 00 00    	je     80105b30 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105a6e:	e8 dd b8 ff ff       	call   80101350 <filealloc>
80105a73:	89 c7                	mov    %eax,%edi
80105a75:	85 c0                	test   %eax,%eax
80105a77:	74 23                	je     80105a9c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105a79:	e8 62 e4 ff ff       	call   80103ee0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a7e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105a80:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105a84:	85 d2                	test   %edx,%edx
80105a86:	74 60                	je     80105ae8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105a88:	83 c3 01             	add    $0x1,%ebx
80105a8b:	83 fb 10             	cmp    $0x10,%ebx
80105a8e:	75 f0                	jne    80105a80 <sys_open+0x80>
    if(f)
      fileclose(f);
80105a90:	83 ec 0c             	sub    $0xc,%esp
80105a93:	57                   	push   %edi
80105a94:	e8 77 b9 ff ff       	call   80101410 <fileclose>
80105a99:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105a9c:	83 ec 0c             	sub    $0xc,%esp
80105a9f:	56                   	push   %esi
80105aa0:	e8 ab c4 ff ff       	call   80101f50 <iunlockput>
    end_op();
80105aa5:	e8 46 d8 ff ff       	call   801032f0 <end_op>
    return -1;
80105aaa:	83 c4 10             	add    $0x10,%esp
80105aad:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ab2:	eb 6d                	jmp    80105b21 <sys_open+0x121>
80105ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105ab8:	83 ec 0c             	sub    $0xc,%esp
80105abb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105abe:	31 c9                	xor    %ecx,%ecx
80105ac0:	ba 02 00 00 00       	mov    $0x2,%edx
80105ac5:	6a 00                	push   $0x0
80105ac7:	e8 24 f8 ff ff       	call   801052f0 <create>
    if(ip == 0){
80105acc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105acf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105ad1:	85 c0                	test   %eax,%eax
80105ad3:	75 99                	jne    80105a6e <sys_open+0x6e>
      end_op();
80105ad5:	e8 16 d8 ff ff       	call   801032f0 <end_op>
      return -1;
80105ada:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105adf:	eb 40                	jmp    80105b21 <sys_open+0x121>
80105ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105ae8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105aeb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105aef:	56                   	push   %esi
80105af0:	e8 9b c2 ff ff       	call   80101d90 <iunlock>
  end_op();
80105af5:	e8 f6 d7 ff ff       	call   801032f0 <end_op>

  f->type = FD_INODE;
80105afa:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105b00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b03:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105b06:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105b09:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105b0b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105b12:	f7 d0                	not    %eax
80105b14:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b17:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105b1a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b1d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105b21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b24:	89 d8                	mov    %ebx,%eax
80105b26:	5b                   	pop    %ebx
80105b27:	5e                   	pop    %esi
80105b28:	5f                   	pop    %edi
80105b29:	5d                   	pop    %ebp
80105b2a:	c3                   	ret    
80105b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b2f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b30:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105b33:	85 c9                	test   %ecx,%ecx
80105b35:	0f 84 33 ff ff ff    	je     80105a6e <sys_open+0x6e>
80105b3b:	e9 5c ff ff ff       	jmp    80105a9c <sys_open+0x9c>

80105b40 <sys_mkdir>:

int
sys_mkdir(void)
{
80105b40:	f3 0f 1e fb          	endbr32 
80105b44:	55                   	push   %ebp
80105b45:	89 e5                	mov    %esp,%ebp
80105b47:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105b4a:	e8 31 d7 ff ff       	call   80103280 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105b4f:	83 ec 08             	sub    $0x8,%esp
80105b52:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b55:	50                   	push   %eax
80105b56:	6a 00                	push   $0x0
80105b58:	e8 e3 f6 ff ff       	call   80105240 <argstr>
80105b5d:	83 c4 10             	add    $0x10,%esp
80105b60:	85 c0                	test   %eax,%eax
80105b62:	78 34                	js     80105b98 <sys_mkdir+0x58>
80105b64:	83 ec 0c             	sub    $0xc,%esp
80105b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b6a:	31 c9                	xor    %ecx,%ecx
80105b6c:	ba 01 00 00 00       	mov    $0x1,%edx
80105b71:	6a 00                	push   $0x0
80105b73:	e8 78 f7 ff ff       	call   801052f0 <create>
80105b78:	83 c4 10             	add    $0x10,%esp
80105b7b:	85 c0                	test   %eax,%eax
80105b7d:	74 19                	je     80105b98 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b7f:	83 ec 0c             	sub    $0xc,%esp
80105b82:	50                   	push   %eax
80105b83:	e8 c8 c3 ff ff       	call   80101f50 <iunlockput>
  end_op();
80105b88:	e8 63 d7 ff ff       	call   801032f0 <end_op>
  return 0;
80105b8d:	83 c4 10             	add    $0x10,%esp
80105b90:	31 c0                	xor    %eax,%eax
}
80105b92:	c9                   	leave  
80105b93:	c3                   	ret    
80105b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105b98:	e8 53 d7 ff ff       	call   801032f0 <end_op>
    return -1;
80105b9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ba2:	c9                   	leave  
80105ba3:	c3                   	ret    
80105ba4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105baf:	90                   	nop

80105bb0 <sys_mknod>:

int
sys_mknod(void)
{
80105bb0:	f3 0f 1e fb          	endbr32 
80105bb4:	55                   	push   %ebp
80105bb5:	89 e5                	mov    %esp,%ebp
80105bb7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105bba:	e8 c1 d6 ff ff       	call   80103280 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105bbf:	83 ec 08             	sub    $0x8,%esp
80105bc2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105bc5:	50                   	push   %eax
80105bc6:	6a 00                	push   $0x0
80105bc8:	e8 73 f6 ff ff       	call   80105240 <argstr>
80105bcd:	83 c4 10             	add    $0x10,%esp
80105bd0:	85 c0                	test   %eax,%eax
80105bd2:	78 64                	js     80105c38 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105bd4:	83 ec 08             	sub    $0x8,%esp
80105bd7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bda:	50                   	push   %eax
80105bdb:	6a 01                	push   $0x1
80105bdd:	e8 ae f5 ff ff       	call   80105190 <argint>
  if((argstr(0, &path)) < 0 ||
80105be2:	83 c4 10             	add    $0x10,%esp
80105be5:	85 c0                	test   %eax,%eax
80105be7:	78 4f                	js     80105c38 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105be9:	83 ec 08             	sub    $0x8,%esp
80105bec:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bef:	50                   	push   %eax
80105bf0:	6a 02                	push   $0x2
80105bf2:	e8 99 f5 ff ff       	call   80105190 <argint>
     argint(1, &major) < 0 ||
80105bf7:	83 c4 10             	add    $0x10,%esp
80105bfa:	85 c0                	test   %eax,%eax
80105bfc:	78 3a                	js     80105c38 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105bfe:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105c02:	83 ec 0c             	sub    $0xc,%esp
80105c05:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105c09:	ba 03 00 00 00       	mov    $0x3,%edx
80105c0e:	50                   	push   %eax
80105c0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105c12:	e8 d9 f6 ff ff       	call   801052f0 <create>
     argint(2, &minor) < 0 ||
80105c17:	83 c4 10             	add    $0x10,%esp
80105c1a:	85 c0                	test   %eax,%eax
80105c1c:	74 1a                	je     80105c38 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c1e:	83 ec 0c             	sub    $0xc,%esp
80105c21:	50                   	push   %eax
80105c22:	e8 29 c3 ff ff       	call   80101f50 <iunlockput>
  end_op();
80105c27:	e8 c4 d6 ff ff       	call   801032f0 <end_op>
  return 0;
80105c2c:	83 c4 10             	add    $0x10,%esp
80105c2f:	31 c0                	xor    %eax,%eax
}
80105c31:	c9                   	leave  
80105c32:	c3                   	ret    
80105c33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c37:	90                   	nop
    end_op();
80105c38:	e8 b3 d6 ff ff       	call   801032f0 <end_op>
    return -1;
80105c3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c42:	c9                   	leave  
80105c43:	c3                   	ret    
80105c44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c4f:	90                   	nop

80105c50 <sys_chdir>:

int
sys_chdir(void)
{
80105c50:	f3 0f 1e fb          	endbr32 
80105c54:	55                   	push   %ebp
80105c55:	89 e5                	mov    %esp,%ebp
80105c57:	56                   	push   %esi
80105c58:	53                   	push   %ebx
80105c59:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105c5c:	e8 7f e2 ff ff       	call   80103ee0 <myproc>
80105c61:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105c63:	e8 18 d6 ff ff       	call   80103280 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105c68:	83 ec 08             	sub    $0x8,%esp
80105c6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c6e:	50                   	push   %eax
80105c6f:	6a 00                	push   $0x0
80105c71:	e8 ca f5 ff ff       	call   80105240 <argstr>
80105c76:	83 c4 10             	add    $0x10,%esp
80105c79:	85 c0                	test   %eax,%eax
80105c7b:	78 73                	js     80105cf0 <sys_chdir+0xa0>
80105c7d:	83 ec 0c             	sub    $0xc,%esp
80105c80:	ff 75 f4             	pushl  -0xc(%ebp)
80105c83:	e8 f8 c8 ff ff       	call   80102580 <namei>
80105c88:	83 c4 10             	add    $0x10,%esp
80105c8b:	89 c3                	mov    %eax,%ebx
80105c8d:	85 c0                	test   %eax,%eax
80105c8f:	74 5f                	je     80105cf0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105c91:	83 ec 0c             	sub    $0xc,%esp
80105c94:	50                   	push   %eax
80105c95:	e8 16 c0 ff ff       	call   80101cb0 <ilock>
  if(ip->type != T_DIR){
80105c9a:	83 c4 10             	add    $0x10,%esp
80105c9d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ca2:	75 2c                	jne    80105cd0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ca4:	83 ec 0c             	sub    $0xc,%esp
80105ca7:	53                   	push   %ebx
80105ca8:	e8 e3 c0 ff ff       	call   80101d90 <iunlock>
  iput(curproc->cwd);
80105cad:	58                   	pop    %eax
80105cae:	ff 76 68             	pushl  0x68(%esi)
80105cb1:	e8 2a c1 ff ff       	call   80101de0 <iput>
  end_op();
80105cb6:	e8 35 d6 ff ff       	call   801032f0 <end_op>
  curproc->cwd = ip;
80105cbb:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105cbe:	83 c4 10             	add    $0x10,%esp
80105cc1:	31 c0                	xor    %eax,%eax
}
80105cc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105cc6:	5b                   	pop    %ebx
80105cc7:	5e                   	pop    %esi
80105cc8:	5d                   	pop    %ebp
80105cc9:	c3                   	ret    
80105cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105cd0:	83 ec 0c             	sub    $0xc,%esp
80105cd3:	53                   	push   %ebx
80105cd4:	e8 77 c2 ff ff       	call   80101f50 <iunlockput>
    end_op();
80105cd9:	e8 12 d6 ff ff       	call   801032f0 <end_op>
    return -1;
80105cde:	83 c4 10             	add    $0x10,%esp
80105ce1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ce6:	eb db                	jmp    80105cc3 <sys_chdir+0x73>
80105ce8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cef:	90                   	nop
    end_op();
80105cf0:	e8 fb d5 ff ff       	call   801032f0 <end_op>
    return -1;
80105cf5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cfa:	eb c7                	jmp    80105cc3 <sys_chdir+0x73>
80105cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d00 <sys_exec>:

int
sys_exec(void)
{
80105d00:	f3 0f 1e fb          	endbr32 
80105d04:	55                   	push   %ebp
80105d05:	89 e5                	mov    %esp,%ebp
80105d07:	57                   	push   %edi
80105d08:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d09:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105d0f:	53                   	push   %ebx
80105d10:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d16:	50                   	push   %eax
80105d17:	6a 00                	push   $0x0
80105d19:	e8 22 f5 ff ff       	call   80105240 <argstr>
80105d1e:	83 c4 10             	add    $0x10,%esp
80105d21:	85 c0                	test   %eax,%eax
80105d23:	0f 88 8b 00 00 00    	js     80105db4 <sys_exec+0xb4>
80105d29:	83 ec 08             	sub    $0x8,%esp
80105d2c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105d32:	50                   	push   %eax
80105d33:	6a 01                	push   $0x1
80105d35:	e8 56 f4 ff ff       	call   80105190 <argint>
80105d3a:	83 c4 10             	add    $0x10,%esp
80105d3d:	85 c0                	test   %eax,%eax
80105d3f:	78 73                	js     80105db4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105d41:	83 ec 04             	sub    $0x4,%esp
80105d44:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105d4a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105d4c:	68 80 00 00 00       	push   $0x80
80105d51:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105d57:	6a 00                	push   $0x0
80105d59:	50                   	push   %eax
80105d5a:	e8 51 f1 ff ff       	call   80104eb0 <memset>
80105d5f:	83 c4 10             	add    $0x10,%esp
80105d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105d68:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105d6e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105d75:	83 ec 08             	sub    $0x8,%esp
80105d78:	57                   	push   %edi
80105d79:	01 f0                	add    %esi,%eax
80105d7b:	50                   	push   %eax
80105d7c:	e8 6f f3 ff ff       	call   801050f0 <fetchint>
80105d81:	83 c4 10             	add    $0x10,%esp
80105d84:	85 c0                	test   %eax,%eax
80105d86:	78 2c                	js     80105db4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105d88:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105d8e:	85 c0                	test   %eax,%eax
80105d90:	74 36                	je     80105dc8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105d92:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105d98:	83 ec 08             	sub    $0x8,%esp
80105d9b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105d9e:	52                   	push   %edx
80105d9f:	50                   	push   %eax
80105da0:	e8 8b f3 ff ff       	call   80105130 <fetchstr>
80105da5:	83 c4 10             	add    $0x10,%esp
80105da8:	85 c0                	test   %eax,%eax
80105daa:	78 08                	js     80105db4 <sys_exec+0xb4>
  for(i=0;; i++){
80105dac:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105daf:	83 fb 20             	cmp    $0x20,%ebx
80105db2:	75 b4                	jne    80105d68 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105db4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105db7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dbc:	5b                   	pop    %ebx
80105dbd:	5e                   	pop    %esi
80105dbe:	5f                   	pop    %edi
80105dbf:	5d                   	pop    %ebp
80105dc0:	c3                   	ret    
80105dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105dc8:	83 ec 08             	sub    $0x8,%esp
80105dcb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105dd1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105dd8:	00 00 00 00 
  return exec(path, argv);
80105ddc:	50                   	push   %eax
80105ddd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105de3:	e8 e8 b1 ff ff       	call   80100fd0 <exec>
80105de8:	83 c4 10             	add    $0x10,%esp
}
80105deb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dee:	5b                   	pop    %ebx
80105def:	5e                   	pop    %esi
80105df0:	5f                   	pop    %edi
80105df1:	5d                   	pop    %ebp
80105df2:	c3                   	ret    
80105df3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e00 <sys_pipe>:

int
sys_pipe(void)
{
80105e00:	f3 0f 1e fb          	endbr32 
80105e04:	55                   	push   %ebp
80105e05:	89 e5                	mov    %esp,%ebp
80105e07:	57                   	push   %edi
80105e08:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e09:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105e0c:	53                   	push   %ebx
80105e0d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e10:	6a 08                	push   $0x8
80105e12:	50                   	push   %eax
80105e13:	6a 00                	push   $0x0
80105e15:	e8 c6 f3 ff ff       	call   801051e0 <argptr>
80105e1a:	83 c4 10             	add    $0x10,%esp
80105e1d:	85 c0                	test   %eax,%eax
80105e1f:	78 4e                	js     80105e6f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105e21:	83 ec 08             	sub    $0x8,%esp
80105e24:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e27:	50                   	push   %eax
80105e28:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e2b:	50                   	push   %eax
80105e2c:	e8 0f db ff ff       	call   80103940 <pipealloc>
80105e31:	83 c4 10             	add    $0x10,%esp
80105e34:	85 c0                	test   %eax,%eax
80105e36:	78 37                	js     80105e6f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e38:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105e3b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105e3d:	e8 9e e0 ff ff       	call   80103ee0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105e48:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105e4c:	85 f6                	test   %esi,%esi
80105e4e:	74 30                	je     80105e80 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105e50:	83 c3 01             	add    $0x1,%ebx
80105e53:	83 fb 10             	cmp    $0x10,%ebx
80105e56:	75 f0                	jne    80105e48 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105e58:	83 ec 0c             	sub    $0xc,%esp
80105e5b:	ff 75 e0             	pushl  -0x20(%ebp)
80105e5e:	e8 ad b5 ff ff       	call   80101410 <fileclose>
    fileclose(wf);
80105e63:	58                   	pop    %eax
80105e64:	ff 75 e4             	pushl  -0x1c(%ebp)
80105e67:	e8 a4 b5 ff ff       	call   80101410 <fileclose>
    return -1;
80105e6c:	83 c4 10             	add    $0x10,%esp
80105e6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e74:	eb 5b                	jmp    80105ed1 <sys_pipe+0xd1>
80105e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e7d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105e80:	8d 73 08             	lea    0x8(%ebx),%esi
80105e83:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e87:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105e8a:	e8 51 e0 ff ff       	call   80103ee0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e8f:	31 d2                	xor    %edx,%edx
80105e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105e98:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105e9c:	85 c9                	test   %ecx,%ecx
80105e9e:	74 20                	je     80105ec0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105ea0:	83 c2 01             	add    $0x1,%edx
80105ea3:	83 fa 10             	cmp    $0x10,%edx
80105ea6:	75 f0                	jne    80105e98 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105ea8:	e8 33 e0 ff ff       	call   80103ee0 <myproc>
80105ead:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105eb4:	00 
80105eb5:	eb a1                	jmp    80105e58 <sys_pipe+0x58>
80105eb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ebe:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105ec0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105ec4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ec7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105ec9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ecc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105ecf:	31 c0                	xor    %eax,%eax
}
80105ed1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ed4:	5b                   	pop    %ebx
80105ed5:	5e                   	pop    %esi
80105ed6:	5f                   	pop    %edi
80105ed7:	5d                   	pop    %ebp
80105ed8:	c3                   	ret    
80105ed9:	66 90                	xchg   %ax,%ax
80105edb:	66 90                	xchg   %ax,%ax
80105edd:	66 90                	xchg   %ax,%ax
80105edf:	90                   	nop

80105ee0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105ee0:	f3 0f 1e fb          	endbr32 
  return fork();
80105ee4:	e9 a7 e1 ff ff       	jmp    80104090 <fork>
80105ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ef0 <sys_exit>:
}

int
sys_exit(void)
{
80105ef0:	f3 0f 1e fb          	endbr32 
80105ef4:	55                   	push   %ebp
80105ef5:	89 e5                	mov    %esp,%ebp
80105ef7:	83 ec 08             	sub    $0x8,%esp
  exit();
80105efa:	e8 11 e4 ff ff       	call   80104310 <exit>
  return 0;  // not reached
}
80105eff:	31 c0                	xor    %eax,%eax
80105f01:	c9                   	leave  
80105f02:	c3                   	ret    
80105f03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f10 <sys_wait>:

int
sys_wait(void)
{
80105f10:	f3 0f 1e fb          	endbr32 
  return wait();
80105f14:	e9 47 e6 ff ff       	jmp    80104560 <wait>
80105f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f20 <sys_kill>:
}

int
sys_kill(void)
{
80105f20:	f3 0f 1e fb          	endbr32 
80105f24:	55                   	push   %ebp
80105f25:	89 e5                	mov    %esp,%ebp
80105f27:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105f2a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f2d:	50                   	push   %eax
80105f2e:	6a 00                	push   $0x0
80105f30:	e8 5b f2 ff ff       	call   80105190 <argint>
80105f35:	83 c4 10             	add    $0x10,%esp
80105f38:	85 c0                	test   %eax,%eax
80105f3a:	78 14                	js     80105f50 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105f3c:	83 ec 0c             	sub    $0xc,%esp
80105f3f:	ff 75 f4             	pushl  -0xc(%ebp)
80105f42:	e8 89 e7 ff ff       	call   801046d0 <kill>
80105f47:	83 c4 10             	add    $0x10,%esp
}
80105f4a:	c9                   	leave  
80105f4b:	c3                   	ret    
80105f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f50:	c9                   	leave  
    return -1;
80105f51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f56:	c3                   	ret    
80105f57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f5e:	66 90                	xchg   %ax,%ax

80105f60 <sys_getpid>:

int
sys_getpid(void)
{
80105f60:	f3 0f 1e fb          	endbr32 
80105f64:	55                   	push   %ebp
80105f65:	89 e5                	mov    %esp,%ebp
80105f67:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105f6a:	e8 71 df ff ff       	call   80103ee0 <myproc>
80105f6f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105f72:	c9                   	leave  
80105f73:	c3                   	ret    
80105f74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f7f:	90                   	nop

80105f80 <sys_sbrk>:

int
sys_sbrk(void)
{
80105f80:	f3 0f 1e fb          	endbr32 
80105f84:	55                   	push   %ebp
80105f85:	89 e5                	mov    %esp,%ebp
80105f87:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f88:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f8b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105f8e:	50                   	push   %eax
80105f8f:	6a 00                	push   $0x0
80105f91:	e8 fa f1 ff ff       	call   80105190 <argint>
80105f96:	83 c4 10             	add    $0x10,%esp
80105f99:	85 c0                	test   %eax,%eax
80105f9b:	78 23                	js     80105fc0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105f9d:	e8 3e df ff ff       	call   80103ee0 <myproc>
  if(growproc(n) < 0)
80105fa2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105fa5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105fa7:	ff 75 f4             	pushl  -0xc(%ebp)
80105faa:	e8 61 e0 ff ff       	call   80104010 <growproc>
80105faf:	83 c4 10             	add    $0x10,%esp
80105fb2:	85 c0                	test   %eax,%eax
80105fb4:	78 0a                	js     80105fc0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105fb6:	89 d8                	mov    %ebx,%eax
80105fb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fbb:	c9                   	leave  
80105fbc:	c3                   	ret    
80105fbd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105fc0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105fc5:	eb ef                	jmp    80105fb6 <sys_sbrk+0x36>
80105fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fce:	66 90                	xchg   %ax,%ax

80105fd0 <sys_sleep>:

int
sys_sleep(void)
{
80105fd0:	f3 0f 1e fb          	endbr32 
80105fd4:	55                   	push   %ebp
80105fd5:	89 e5                	mov    %esp,%ebp
80105fd7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105fd8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105fdb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105fde:	50                   	push   %eax
80105fdf:	6a 00                	push   $0x0
80105fe1:	e8 aa f1 ff ff       	call   80105190 <argint>
80105fe6:	83 c4 10             	add    $0x10,%esp
80105fe9:	85 c0                	test   %eax,%eax
80105feb:	0f 88 86 00 00 00    	js     80106077 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105ff1:	83 ec 0c             	sub    $0xc,%esp
80105ff4:	68 a0 7e 11 80       	push   $0x80117ea0
80105ff9:	e8 a2 ed ff ff       	call   80104da0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105ffe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106001:	8b 1d e0 86 11 80    	mov    0x801186e0,%ebx
  while(ticks - ticks0 < n){
80106007:	83 c4 10             	add    $0x10,%esp
8010600a:	85 d2                	test   %edx,%edx
8010600c:	75 23                	jne    80106031 <sys_sleep+0x61>
8010600e:	eb 50                	jmp    80106060 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106010:	83 ec 08             	sub    $0x8,%esp
80106013:	68 a0 7e 11 80       	push   $0x80117ea0
80106018:	68 e0 86 11 80       	push   $0x801186e0
8010601d:	e8 7e e4 ff ff       	call   801044a0 <sleep>
  while(ticks - ticks0 < n){
80106022:	a1 e0 86 11 80       	mov    0x801186e0,%eax
80106027:	83 c4 10             	add    $0x10,%esp
8010602a:	29 d8                	sub    %ebx,%eax
8010602c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010602f:	73 2f                	jae    80106060 <sys_sleep+0x90>
    if(myproc()->killed){
80106031:	e8 aa de ff ff       	call   80103ee0 <myproc>
80106036:	8b 40 24             	mov    0x24(%eax),%eax
80106039:	85 c0                	test   %eax,%eax
8010603b:	74 d3                	je     80106010 <sys_sleep+0x40>
      release(&tickslock);
8010603d:	83 ec 0c             	sub    $0xc,%esp
80106040:	68 a0 7e 11 80       	push   $0x80117ea0
80106045:	e8 16 ee ff ff       	call   80104e60 <release>
  }
  release(&tickslock);
  return 0;
}
8010604a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010604d:	83 c4 10             	add    $0x10,%esp
80106050:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106055:	c9                   	leave  
80106056:	c3                   	ret    
80106057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010605e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106060:	83 ec 0c             	sub    $0xc,%esp
80106063:	68 a0 7e 11 80       	push   $0x80117ea0
80106068:	e8 f3 ed ff ff       	call   80104e60 <release>
  return 0;
8010606d:	83 c4 10             	add    $0x10,%esp
80106070:	31 c0                	xor    %eax,%eax
}
80106072:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106075:	c9                   	leave  
80106076:	c3                   	ret    
    return -1;
80106077:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010607c:	eb f4                	jmp    80106072 <sys_sleep+0xa2>
8010607e:	66 90                	xchg   %ax,%ax

80106080 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106080:	f3 0f 1e fb          	endbr32 
80106084:	55                   	push   %ebp
80106085:	89 e5                	mov    %esp,%ebp
80106087:	53                   	push   %ebx
80106088:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010608b:	68 a0 7e 11 80       	push   $0x80117ea0
80106090:	e8 0b ed ff ff       	call   80104da0 <acquire>
  xticks = ticks;
80106095:	8b 1d e0 86 11 80    	mov    0x801186e0,%ebx
  release(&tickslock);
8010609b:	c7 04 24 a0 7e 11 80 	movl   $0x80117ea0,(%esp)
801060a2:	e8 b9 ed ff ff       	call   80104e60 <release>
  return xticks;
}
801060a7:	89 d8                	mov    %ebx,%eax
801060a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060ac:	c9                   	leave  
801060ad:	c3                   	ret    
801060ae:	66 90                	xchg   %ax,%ax

801060b0 <sys_find_next_prime_num>:


// find next prime number
int
sys_find_next_prime_num(void)
{
801060b0:	f3 0f 1e fb          	endbr32 
801060b4:	55                   	push   %ebp
801060b5:	89 e5                	mov    %esp,%ebp
801060b7:	53                   	push   %ebx
801060b8:	83 ec 04             	sub    $0x4,%esp
  int a = myproc()->tf->ebx; //register after eax
801060bb:	e8 20 de ff ff       	call   80103ee0 <myproc>
  cprintf("in kernel systemcall sys_find_next_prime_num() called for number %d\n", a);
801060c0:	83 ec 08             	sub    $0x8,%esp
  int a = myproc()->tf->ebx; //register after eax
801060c3:	8b 40 18             	mov    0x18(%eax),%eax
801060c6:	8b 58 10             	mov    0x10(%eax),%ebx
  cprintf("in kernel systemcall sys_find_next_prime_num() called for number %d\n", a);
801060c9:	53                   	push   %ebx
801060ca:	68 bc 82 10 80       	push   $0x801082bc
801060cf:	e8 dc a5 ff ff       	call   801006b0 <cprintf>
  return find_next_prime_num(a);
801060d4:	89 1c 24             	mov    %ebx,(%esp)
801060d7:	e8 64 e7 ff ff       	call   80104840 <find_next_prime_num>
}
801060dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060df:	c9                   	leave  
801060e0:	c3                   	ret    
801060e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ef:	90                   	nop

801060f0 <sys_get_call_count>:

// get parent proc id
int
sys_get_call_count(void)
{
801060f0:	f3 0f 1e fb          	endbr32 
801060f4:	55                   	push   %ebp
801060f5:	89 e5                	mov    %esp,%ebp
801060f7:	83 ec 20             	sub    $0x20,%esp

  int sys_call_num;
  if(argint(0, &sys_call_num) < 0)
801060fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060fd:	50                   	push   %eax
801060fe:	6a 00                	push   $0x0
80106100:	e8 8b f0 ff ff       	call   80105190 <argint>
80106105:	83 c4 10             	add    $0x10,%esp
80106108:	85 c0                	test   %eax,%eax
8010610a:	78 14                	js     80106120 <sys_get_call_count+0x30>
    return -1;
  return get_call_count(sys_call_num);
8010610c:	83 ec 0c             	sub    $0xc,%esp
8010610f:	ff 75 f4             	pushl  -0xc(%ebp)
80106112:	e8 79 e7 ff ff       	call   80104890 <get_call_count>
80106117:	83 c4 10             	add    $0x10,%esp
}
8010611a:	c9                   	leave  
8010611b:	c3                   	ret    
8010611c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106120:	c9                   	leave  
    return -1;
80106121:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106126:	c3                   	ret    
80106127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010612e:	66 90                	xchg   %ax,%ax

80106130 <sys_get_most_caller>:

// get most caller
int
sys_get_most_caller(void)
{
80106130:	f3 0f 1e fb          	endbr32 
80106134:	55                   	push   %ebp
80106135:	89 e5                	mov    %esp,%ebp
80106137:	83 ec 20             	sub    $0x20,%esp

  int sys_call_num;
  if(argint(0, &sys_call_num) < 0)
8010613a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010613d:	50                   	push   %eax
8010613e:	6a 00                	push   $0x0
80106140:	e8 4b f0 ff ff       	call   80105190 <argint>
80106145:	83 c4 10             	add    $0x10,%esp
80106148:	85 c0                	test   %eax,%eax
8010614a:	78 14                	js     80106160 <sys_get_most_caller+0x30>
    return -1;
  return get_most_caller(sys_call_num);
8010614c:	83 ec 0c             	sub    $0xc,%esp
8010614f:	ff 75 f4             	pushl  -0xc(%ebp)
80106152:	e8 69 e7 ff ff       	call   801048c0 <get_most_caller>
80106157:	83 c4 10             	add    $0x10,%esp
}
8010615a:	c9                   	leave  
8010615b:	c3                   	ret    
8010615c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106160:	c9                   	leave  
    return -1;
80106161:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106166:	c3                   	ret    
80106167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010616e:	66 90                	xchg   %ax,%ax

80106170 <sys_wait_for_process>:


// wait for process
void
sys_wait_for_process(void)
{
80106170:	f3 0f 1e fb          	endbr32 
80106174:	55                   	push   %ebp
80106175:	89 e5                	mov    %esp,%ebp
80106177:	83 ec 20             	sub    $0x20,%esp

  int pid;
  argint(0, &pid);
8010617a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010617d:	50                   	push   %eax
8010617e:	6a 00                	push   $0x0
80106180:	e8 0b f0 ff ff       	call   80105190 <argint>
  wait_for_process(pid);
80106185:	58                   	pop    %eax
80106186:	ff 75 f4             	pushl  -0xc(%ebp)
80106189:	e8 72 e7 ff ff       	call   80104900 <wait_for_process>

}
8010618e:	83 c4 10             	add    $0x10,%esp
80106191:	c9                   	leave  
80106192:	c3                   	ret    
80106193:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010619a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801061a0 <sys_sem_init>:

// semaphore operations

int
sys_sem_init(void)
{
801061a0:	f3 0f 1e fb          	endbr32 
801061a4:	55                   	push   %ebp
801061a5:	89 e5                	mov    %esp,%ebp
801061a7:	83 ec 20             	sub    $0x20,%esp
  int i, v;
  if(argint(0, &i) < 0 || argint(1, &v))
801061aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061ad:	50                   	push   %eax
801061ae:	6a 00                	push   $0x0
801061b0:	e8 db ef ff ff       	call   80105190 <argint>
801061b5:	83 c4 10             	add    $0x10,%esp
801061b8:	85 c0                	test   %eax,%eax
801061ba:	78 2c                	js     801061e8 <sys_sem_init+0x48>
801061bc:	83 ec 08             	sub    $0x8,%esp
801061bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061c2:	50                   	push   %eax
801061c3:	6a 01                	push   $0x1
801061c5:	e8 c6 ef ff ff       	call   80105190 <argint>
801061ca:	83 c4 10             	add    $0x10,%esp
801061cd:	85 c0                	test   %eax,%eax
801061cf:	75 17                	jne    801061e8 <sys_sem_init+0x48>
    return -1;

  return sem_init(i, v);
801061d1:	83 ec 08             	sub    $0x8,%esp
801061d4:	ff 75 f4             	pushl  -0xc(%ebp)
801061d7:	ff 75 f0             	pushl  -0x10(%ebp)
801061da:	e8 51 e7 ff ff       	call   80104930 <sem_init>
801061df:	83 c4 10             	add    $0x10,%esp

}
801061e2:	c9                   	leave  
801061e3:	c3                   	ret    
801061e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061e8:	c9                   	leave  
    return -1;
801061e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061ee:	c3                   	ret    
801061ef:	90                   	nop

801061f0 <sys_sem_acquire>:

int
sys_sem_acquire(void)
{ 
801061f0:	f3 0f 1e fb          	endbr32 
801061f4:	55                   	push   %ebp
801061f5:	89 e5                	mov    %esp,%ebp
801061f7:	83 ec 20             	sub    $0x20,%esp
  int i;
  if(argint(0, &i) < 0)
801061fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061fd:	50                   	push   %eax
801061fe:	6a 00                	push   $0x0
80106200:	e8 8b ef ff ff       	call   80105190 <argint>
80106205:	83 c4 10             	add    $0x10,%esp
80106208:	85 c0                	test   %eax,%eax
8010620a:	78 14                	js     80106220 <sys_sem_acquire+0x30>
    return -1;
  return sem_acquire(i);
8010620c:	83 ec 0c             	sub    $0xc,%esp
8010620f:	ff 75 f4             	pushl  -0xc(%ebp)
80106212:	e8 69 e7 ff ff       	call   80104980 <sem_acquire>
80106217:	83 c4 10             	add    $0x10,%esp
}
8010621a:	c9                   	leave  
8010621b:	c3                   	ret    
8010621c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106220:	c9                   	leave  
    return -1;
80106221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106226:	c3                   	ret    
80106227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010622e:	66 90                	xchg   %ax,%ax

80106230 <sys_sem_release>:

int
sys_sem_release(void)
{
80106230:	f3 0f 1e fb          	endbr32 
80106234:	55                   	push   %ebp
80106235:	89 e5                	mov    %esp,%ebp
80106237:	83 ec 20             	sub    $0x20,%esp
  int i;
  if(argint(0, &i) < 0)
8010623a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010623d:	50                   	push   %eax
8010623e:	6a 00                	push   $0x0
80106240:	e8 4b ef ff ff       	call   80105190 <argint>
80106245:	83 c4 10             	add    $0x10,%esp
80106248:	85 c0                	test   %eax,%eax
8010624a:	78 14                	js     80106260 <sys_sem_release+0x30>
    return -1;
  return sem_release(i);
8010624c:	83 ec 0c             	sub    $0xc,%esp
8010624f:	ff 75 f4             	pushl  -0xc(%ebp)
80106252:	e8 a9 e7 ff ff       	call   80104a00 <sem_release>
80106257:	83 c4 10             	add    $0x10,%esp
}
8010625a:	c9                   	leave  
8010625b:	c3                   	ret    
8010625c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106260:	c9                   	leave  
    return -1;
80106261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106266:	c3                   	ret    
80106267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010626e:	66 90                	xchg   %ax,%ax

80106270 <sys_multiple_acquire>:


// multiple acquire
void
sys_multiple_acquire(void)
{
80106270:	f3 0f 1e fb          	endbr32 
80106274:	55                   	push   %ebp
80106275:	89 e5                	mov    %esp,%ebp
80106277:	83 ec 20             	sub    $0x20,%esp
  int cnt;
  argint(0, &cnt);
8010627a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010627d:	50                   	push   %eax
8010627e:	6a 00                	push   $0x0
80106280:	e8 0b ef ff ff       	call   80105190 <argint>
  multiple_acquire(cnt);
80106285:	58                   	pop    %eax
80106286:	ff 75 f4             	pushl  -0xc(%ebp)
80106289:	e8 02 e8 ff ff       	call   80104a90 <multiple_acquire>
8010628e:	83 c4 10             	add    $0x10,%esp
80106291:	c9                   	leave  
80106292:	c3                   	ret    

80106293 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106293:	1e                   	push   %ds
  pushl %es
80106294:	06                   	push   %es
  pushl %fs
80106295:	0f a0                	push   %fs
  pushl %gs
80106297:	0f a8                	push   %gs
  pushal
80106299:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010629a:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010629e:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801062a0:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801062a2:	54                   	push   %esp
  call trap
801062a3:	e8 c8 00 00 00       	call   80106370 <trap>
  addl $4, %esp
801062a8:	83 c4 04             	add    $0x4,%esp

801062ab <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801062ab:	61                   	popa   
  popl %gs
801062ac:	0f a9                	pop    %gs
  popl %fs
801062ae:	0f a1                	pop    %fs
  popl %es
801062b0:	07                   	pop    %es
  popl %ds
801062b1:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801062b2:	83 c4 08             	add    $0x8,%esp
  iret
801062b5:	cf                   	iret   
801062b6:	66 90                	xchg   %ax,%ax
801062b8:	66 90                	xchg   %ax,%ax
801062ba:	66 90                	xchg   %ax,%ax
801062bc:	66 90                	xchg   %ax,%ax
801062be:	66 90                	xchg   %ax,%ax

801062c0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801062c0:	f3 0f 1e fb          	endbr32 
801062c4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801062c5:	31 c0                	xor    %eax,%eax
{
801062c7:	89 e5                	mov    %esp,%ebp
801062c9:	83 ec 08             	sub    $0x8,%esp
801062cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801062d0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801062d7:	c7 04 c5 e2 7e 11 80 	movl   $0x8e000008,-0x7fee811e(,%eax,8)
801062de:	08 00 00 8e 
801062e2:	66 89 14 c5 e0 7e 11 	mov    %dx,-0x7fee8120(,%eax,8)
801062e9:	80 
801062ea:	c1 ea 10             	shr    $0x10,%edx
801062ed:	66 89 14 c5 e6 7e 11 	mov    %dx,-0x7fee811a(,%eax,8)
801062f4:	80 
  for(i = 0; i < 256; i++)
801062f5:	83 c0 01             	add    $0x1,%eax
801062f8:	3d 00 01 00 00       	cmp    $0x100,%eax
801062fd:	75 d1                	jne    801062d0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801062ff:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106302:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106307:	c7 05 e2 80 11 80 08 	movl   $0xef000008,0x801180e2
8010630e:	00 00 ef 
  initlock(&tickslock, "time");
80106311:	68 01 83 10 80       	push   $0x80108301
80106316:	68 a0 7e 11 80       	push   $0x80117ea0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010631b:	66 a3 e0 80 11 80    	mov    %ax,0x801180e0
80106321:	c1 e8 10             	shr    $0x10,%eax
80106324:	66 a3 e6 80 11 80    	mov    %ax,0x801180e6
  initlock(&tickslock, "time");
8010632a:	e8 f1 e8 ff ff       	call   80104c20 <initlock>
}
8010632f:	83 c4 10             	add    $0x10,%esp
80106332:	c9                   	leave  
80106333:	c3                   	ret    
80106334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010633b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010633f:	90                   	nop

80106340 <idtinit>:

void
idtinit(void)
{
80106340:	f3 0f 1e fb          	endbr32 
80106344:	55                   	push   %ebp
  pd[0] = size-1;
80106345:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010634a:	89 e5                	mov    %esp,%ebp
8010634c:	83 ec 10             	sub    $0x10,%esp
8010634f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106353:	b8 e0 7e 11 80       	mov    $0x80117ee0,%eax
80106358:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010635c:	c1 e8 10             	shr    $0x10,%eax
8010635f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106363:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106366:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106369:	c9                   	leave  
8010636a:	c3                   	ret    
8010636b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010636f:	90                   	nop

80106370 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106370:	f3 0f 1e fb          	endbr32 
80106374:	55                   	push   %ebp
80106375:	89 e5                	mov    %esp,%ebp
80106377:	57                   	push   %edi
80106378:	56                   	push   %esi
80106379:	53                   	push   %ebx
8010637a:	83 ec 1c             	sub    $0x1c,%esp
8010637d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106380:	8b 43 30             	mov    0x30(%ebx),%eax
80106383:	83 f8 40             	cmp    $0x40,%eax
80106386:	0f 84 bc 01 00 00    	je     80106548 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010638c:	83 e8 20             	sub    $0x20,%eax
8010638f:	83 f8 1f             	cmp    $0x1f,%eax
80106392:	77 08                	ja     8010639c <trap+0x2c>
80106394:	3e ff 24 85 a8 83 10 	notrack jmp *-0x7fef7c58(,%eax,4)
8010639b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010639c:	e8 3f db ff ff       	call   80103ee0 <myproc>
801063a1:	8b 7b 38             	mov    0x38(%ebx),%edi
801063a4:	85 c0                	test   %eax,%eax
801063a6:	0f 84 eb 01 00 00    	je     80106597 <trap+0x227>
801063ac:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801063b0:	0f 84 e1 01 00 00    	je     80106597 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801063b6:	0f 20 d1             	mov    %cr2,%ecx
801063b9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063bc:	e8 ff da ff ff       	call   80103ec0 <cpuid>
801063c1:	8b 73 30             	mov    0x30(%ebx),%esi
801063c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
801063c7:	8b 43 34             	mov    0x34(%ebx),%eax
801063ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801063cd:	e8 0e db ff ff       	call   80103ee0 <myproc>
801063d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801063d5:	e8 06 db ff ff       	call   80103ee0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063da:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801063dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801063e0:	51                   	push   %ecx
801063e1:	57                   	push   %edi
801063e2:	52                   	push   %edx
801063e3:	ff 75 e4             	pushl  -0x1c(%ebp)
801063e6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801063e7:	8b 75 e0             	mov    -0x20(%ebp),%esi
801063ea:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063ed:	56                   	push   %esi
801063ee:	ff 70 10             	pushl  0x10(%eax)
801063f1:	68 64 83 10 80       	push   $0x80108364
801063f6:	e8 b5 a2 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801063fb:	83 c4 20             	add    $0x20,%esp
801063fe:	e8 dd da ff ff       	call   80103ee0 <myproc>
80106403:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010640a:	e8 d1 da ff ff       	call   80103ee0 <myproc>
8010640f:	85 c0                	test   %eax,%eax
80106411:	74 1d                	je     80106430 <trap+0xc0>
80106413:	e8 c8 da ff ff       	call   80103ee0 <myproc>
80106418:	8b 50 24             	mov    0x24(%eax),%edx
8010641b:	85 d2                	test   %edx,%edx
8010641d:	74 11                	je     80106430 <trap+0xc0>
8010641f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106423:	83 e0 03             	and    $0x3,%eax
80106426:	66 83 f8 03          	cmp    $0x3,%ax
8010642a:	0f 84 50 01 00 00    	je     80106580 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106430:	e8 ab da ff ff       	call   80103ee0 <myproc>
80106435:	85 c0                	test   %eax,%eax
80106437:	74 0f                	je     80106448 <trap+0xd8>
80106439:	e8 a2 da ff ff       	call   80103ee0 <myproc>
8010643e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106442:	0f 84 e8 00 00 00    	je     80106530 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106448:	e8 93 da ff ff       	call   80103ee0 <myproc>
8010644d:	85 c0                	test   %eax,%eax
8010644f:	74 1d                	je     8010646e <trap+0xfe>
80106451:	e8 8a da ff ff       	call   80103ee0 <myproc>
80106456:	8b 40 24             	mov    0x24(%eax),%eax
80106459:	85 c0                	test   %eax,%eax
8010645b:	74 11                	je     8010646e <trap+0xfe>
8010645d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106461:	83 e0 03             	and    $0x3,%eax
80106464:	66 83 f8 03          	cmp    $0x3,%ax
80106468:	0f 84 03 01 00 00    	je     80106571 <trap+0x201>
    exit();
}
8010646e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106471:	5b                   	pop    %ebx
80106472:	5e                   	pop    %esi
80106473:	5f                   	pop    %edi
80106474:	5d                   	pop    %ebp
80106475:	c3                   	ret    
    ideintr();
80106476:	e8 b5 c2 ff ff       	call   80102730 <ideintr>
    lapiceoi();
8010647b:	e8 90 c9 ff ff       	call   80102e10 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106480:	e8 5b da ff ff       	call   80103ee0 <myproc>
80106485:	85 c0                	test   %eax,%eax
80106487:	75 8a                	jne    80106413 <trap+0xa3>
80106489:	eb a5                	jmp    80106430 <trap+0xc0>
    if(cpuid() == 0){
8010648b:	e8 30 da ff ff       	call   80103ec0 <cpuid>
80106490:	85 c0                	test   %eax,%eax
80106492:	75 e7                	jne    8010647b <trap+0x10b>
      acquire(&tickslock);
80106494:	83 ec 0c             	sub    $0xc,%esp
80106497:	68 a0 7e 11 80       	push   $0x80117ea0
8010649c:	e8 ff e8 ff ff       	call   80104da0 <acquire>
      wakeup(&ticks);
801064a1:	c7 04 24 e0 86 11 80 	movl   $0x801186e0,(%esp)
      ticks++;
801064a8:	83 05 e0 86 11 80 01 	addl   $0x1,0x801186e0
      wakeup(&ticks);
801064af:	e8 ac e1 ff ff       	call   80104660 <wakeup>
      release(&tickslock);
801064b4:	c7 04 24 a0 7e 11 80 	movl   $0x80117ea0,(%esp)
801064bb:	e8 a0 e9 ff ff       	call   80104e60 <release>
801064c0:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801064c3:	eb b6                	jmp    8010647b <trap+0x10b>
    kbdintr();
801064c5:	e8 06 c8 ff ff       	call   80102cd0 <kbdintr>
    lapiceoi();
801064ca:	e8 41 c9 ff ff       	call   80102e10 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064cf:	e8 0c da ff ff       	call   80103ee0 <myproc>
801064d4:	85 c0                	test   %eax,%eax
801064d6:	0f 85 37 ff ff ff    	jne    80106413 <trap+0xa3>
801064dc:	e9 4f ff ff ff       	jmp    80106430 <trap+0xc0>
    uartintr();
801064e1:	e8 4a 02 00 00       	call   80106730 <uartintr>
    lapiceoi();
801064e6:	e8 25 c9 ff ff       	call   80102e10 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064eb:	e8 f0 d9 ff ff       	call   80103ee0 <myproc>
801064f0:	85 c0                	test   %eax,%eax
801064f2:	0f 85 1b ff ff ff    	jne    80106413 <trap+0xa3>
801064f8:	e9 33 ff ff ff       	jmp    80106430 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801064fd:	8b 7b 38             	mov    0x38(%ebx),%edi
80106500:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106504:	e8 b7 d9 ff ff       	call   80103ec0 <cpuid>
80106509:	57                   	push   %edi
8010650a:	56                   	push   %esi
8010650b:	50                   	push   %eax
8010650c:	68 0c 83 10 80       	push   $0x8010830c
80106511:	e8 9a a1 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106516:	e8 f5 c8 ff ff       	call   80102e10 <lapiceoi>
    break;
8010651b:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010651e:	e8 bd d9 ff ff       	call   80103ee0 <myproc>
80106523:	85 c0                	test   %eax,%eax
80106525:	0f 85 e8 fe ff ff    	jne    80106413 <trap+0xa3>
8010652b:	e9 00 ff ff ff       	jmp    80106430 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80106530:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106534:	0f 85 0e ff ff ff    	jne    80106448 <trap+0xd8>
    yield();
8010653a:	e8 11 df ff ff       	call   80104450 <yield>
8010653f:	e9 04 ff ff ff       	jmp    80106448 <trap+0xd8>
80106544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106548:	e8 93 d9 ff ff       	call   80103ee0 <myproc>
8010654d:	8b 70 24             	mov    0x24(%eax),%esi
80106550:	85 f6                	test   %esi,%esi
80106552:	75 3c                	jne    80106590 <trap+0x220>
    myproc()->tf = tf;
80106554:	e8 87 d9 ff ff       	call   80103ee0 <myproc>
80106559:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010655c:	e8 1f ed ff ff       	call   80105280 <syscall>
    if(myproc()->killed)
80106561:	e8 7a d9 ff ff       	call   80103ee0 <myproc>
80106566:	8b 48 24             	mov    0x24(%eax),%ecx
80106569:	85 c9                	test   %ecx,%ecx
8010656b:	0f 84 fd fe ff ff    	je     8010646e <trap+0xfe>
}
80106571:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106574:	5b                   	pop    %ebx
80106575:	5e                   	pop    %esi
80106576:	5f                   	pop    %edi
80106577:	5d                   	pop    %ebp
      exit();
80106578:	e9 93 dd ff ff       	jmp    80104310 <exit>
8010657d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106580:	e8 8b dd ff ff       	call   80104310 <exit>
80106585:	e9 a6 fe ff ff       	jmp    80106430 <trap+0xc0>
8010658a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106590:	e8 7b dd ff ff       	call   80104310 <exit>
80106595:	eb bd                	jmp    80106554 <trap+0x1e4>
80106597:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010659a:	e8 21 d9 ff ff       	call   80103ec0 <cpuid>
8010659f:	83 ec 0c             	sub    $0xc,%esp
801065a2:	56                   	push   %esi
801065a3:	57                   	push   %edi
801065a4:	50                   	push   %eax
801065a5:	ff 73 30             	pushl  0x30(%ebx)
801065a8:	68 30 83 10 80       	push   $0x80108330
801065ad:	e8 fe a0 ff ff       	call   801006b0 <cprintf>
      panic("trap");
801065b2:	83 c4 14             	add    $0x14,%esp
801065b5:	68 06 83 10 80       	push   $0x80108306
801065ba:	e8 d1 9d ff ff       	call   80100390 <panic>
801065bf:	90                   	nop

801065c0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801065c0:	f3 0f 1e fb          	endbr32 
  if(!uart)
801065c4:	a1 0c b6 10 80       	mov    0x8010b60c,%eax
801065c9:	85 c0                	test   %eax,%eax
801065cb:	74 1b                	je     801065e8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801065cd:	ba fd 03 00 00       	mov    $0x3fd,%edx
801065d2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801065d3:	a8 01                	test   $0x1,%al
801065d5:	74 11                	je     801065e8 <uartgetc+0x28>
801065d7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065dc:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801065dd:	0f b6 c0             	movzbl %al,%eax
801065e0:	c3                   	ret    
801065e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801065e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065ed:	c3                   	ret    
801065ee:	66 90                	xchg   %ax,%ax

801065f0 <uartputc.part.0>:
uartputc(int c)
801065f0:	55                   	push   %ebp
801065f1:	89 e5                	mov    %esp,%ebp
801065f3:	57                   	push   %edi
801065f4:	89 c7                	mov    %eax,%edi
801065f6:	56                   	push   %esi
801065f7:	be fd 03 00 00       	mov    $0x3fd,%esi
801065fc:	53                   	push   %ebx
801065fd:	bb 80 00 00 00       	mov    $0x80,%ebx
80106602:	83 ec 0c             	sub    $0xc,%esp
80106605:	eb 1b                	jmp    80106622 <uartputc.part.0+0x32>
80106607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010660e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106610:	83 ec 0c             	sub    $0xc,%esp
80106613:	6a 0a                	push   $0xa
80106615:	e8 16 c8 ff ff       	call   80102e30 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010661a:	83 c4 10             	add    $0x10,%esp
8010661d:	83 eb 01             	sub    $0x1,%ebx
80106620:	74 07                	je     80106629 <uartputc.part.0+0x39>
80106622:	89 f2                	mov    %esi,%edx
80106624:	ec                   	in     (%dx),%al
80106625:	a8 20                	test   $0x20,%al
80106627:	74 e7                	je     80106610 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106629:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010662e:	89 f8                	mov    %edi,%eax
80106630:	ee                   	out    %al,(%dx)
}
80106631:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106634:	5b                   	pop    %ebx
80106635:	5e                   	pop    %esi
80106636:	5f                   	pop    %edi
80106637:	5d                   	pop    %ebp
80106638:	c3                   	ret    
80106639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106640 <uartinit>:
{
80106640:	f3 0f 1e fb          	endbr32 
80106644:	55                   	push   %ebp
80106645:	31 c9                	xor    %ecx,%ecx
80106647:	89 c8                	mov    %ecx,%eax
80106649:	89 e5                	mov    %esp,%ebp
8010664b:	57                   	push   %edi
8010664c:	56                   	push   %esi
8010664d:	53                   	push   %ebx
8010664e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106653:	89 da                	mov    %ebx,%edx
80106655:	83 ec 0c             	sub    $0xc,%esp
80106658:	ee                   	out    %al,(%dx)
80106659:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010665e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106663:	89 fa                	mov    %edi,%edx
80106665:	ee                   	out    %al,(%dx)
80106666:	b8 0c 00 00 00       	mov    $0xc,%eax
8010666b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106670:	ee                   	out    %al,(%dx)
80106671:	be f9 03 00 00       	mov    $0x3f9,%esi
80106676:	89 c8                	mov    %ecx,%eax
80106678:	89 f2                	mov    %esi,%edx
8010667a:	ee                   	out    %al,(%dx)
8010667b:	b8 03 00 00 00       	mov    $0x3,%eax
80106680:	89 fa                	mov    %edi,%edx
80106682:	ee                   	out    %al,(%dx)
80106683:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106688:	89 c8                	mov    %ecx,%eax
8010668a:	ee                   	out    %al,(%dx)
8010668b:	b8 01 00 00 00       	mov    $0x1,%eax
80106690:	89 f2                	mov    %esi,%edx
80106692:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106693:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106698:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106699:	3c ff                	cmp    $0xff,%al
8010669b:	74 52                	je     801066ef <uartinit+0xaf>
  uart = 1;
8010669d:	c7 05 0c b6 10 80 01 	movl   $0x1,0x8010b60c
801066a4:	00 00 00 
801066a7:	89 da                	mov    %ebx,%edx
801066a9:	ec                   	in     (%dx),%al
801066aa:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066af:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801066b0:	83 ec 08             	sub    $0x8,%esp
801066b3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
801066b8:	bb 28 84 10 80       	mov    $0x80108428,%ebx
  ioapicenable(IRQ_COM1, 0);
801066bd:	6a 00                	push   $0x0
801066bf:	6a 04                	push   $0x4
801066c1:	e8 ba c2 ff ff       	call   80102980 <ioapicenable>
801066c6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801066c9:	b8 78 00 00 00       	mov    $0x78,%eax
801066ce:	eb 04                	jmp    801066d4 <uartinit+0x94>
801066d0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
801066d4:	8b 15 0c b6 10 80    	mov    0x8010b60c,%edx
801066da:	85 d2                	test   %edx,%edx
801066dc:	74 08                	je     801066e6 <uartinit+0xa6>
    uartputc(*p);
801066de:	0f be c0             	movsbl %al,%eax
801066e1:	e8 0a ff ff ff       	call   801065f0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
801066e6:	89 f0                	mov    %esi,%eax
801066e8:	83 c3 01             	add    $0x1,%ebx
801066eb:	84 c0                	test   %al,%al
801066ed:	75 e1                	jne    801066d0 <uartinit+0x90>
}
801066ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066f2:	5b                   	pop    %ebx
801066f3:	5e                   	pop    %esi
801066f4:	5f                   	pop    %edi
801066f5:	5d                   	pop    %ebp
801066f6:	c3                   	ret    
801066f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066fe:	66 90                	xchg   %ax,%ax

80106700 <uartputc>:
{
80106700:	f3 0f 1e fb          	endbr32 
80106704:	55                   	push   %ebp
  if(!uart)
80106705:	8b 15 0c b6 10 80    	mov    0x8010b60c,%edx
{
8010670b:	89 e5                	mov    %esp,%ebp
8010670d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106710:	85 d2                	test   %edx,%edx
80106712:	74 0c                	je     80106720 <uartputc+0x20>
}
80106714:	5d                   	pop    %ebp
80106715:	e9 d6 fe ff ff       	jmp    801065f0 <uartputc.part.0>
8010671a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106720:	5d                   	pop    %ebp
80106721:	c3                   	ret    
80106722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106730 <uartintr>:

void
uartintr(void)
{
80106730:	f3 0f 1e fb          	endbr32 
80106734:	55                   	push   %ebp
80106735:	89 e5                	mov    %esp,%ebp
80106737:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010673a:	68 c0 65 10 80       	push   $0x801065c0
8010673f:	e8 dc a4 ff ff       	call   80100c20 <consoleintr>
}
80106744:	83 c4 10             	add    $0x10,%esp
80106747:	c9                   	leave  
80106748:	c3                   	ret    

80106749 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106749:	6a 00                	push   $0x0
  pushl $0
8010674b:	6a 00                	push   $0x0
  jmp alltraps
8010674d:	e9 41 fb ff ff       	jmp    80106293 <alltraps>

80106752 <vector1>:
.globl vector1
vector1:
  pushl $0
80106752:	6a 00                	push   $0x0
  pushl $1
80106754:	6a 01                	push   $0x1
  jmp alltraps
80106756:	e9 38 fb ff ff       	jmp    80106293 <alltraps>

8010675b <vector2>:
.globl vector2
vector2:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $2
8010675d:	6a 02                	push   $0x2
  jmp alltraps
8010675f:	e9 2f fb ff ff       	jmp    80106293 <alltraps>

80106764 <vector3>:
.globl vector3
vector3:
  pushl $0
80106764:	6a 00                	push   $0x0
  pushl $3
80106766:	6a 03                	push   $0x3
  jmp alltraps
80106768:	e9 26 fb ff ff       	jmp    80106293 <alltraps>

8010676d <vector4>:
.globl vector4
vector4:
  pushl $0
8010676d:	6a 00                	push   $0x0
  pushl $4
8010676f:	6a 04                	push   $0x4
  jmp alltraps
80106771:	e9 1d fb ff ff       	jmp    80106293 <alltraps>

80106776 <vector5>:
.globl vector5
vector5:
  pushl $0
80106776:	6a 00                	push   $0x0
  pushl $5
80106778:	6a 05                	push   $0x5
  jmp alltraps
8010677a:	e9 14 fb ff ff       	jmp    80106293 <alltraps>

8010677f <vector6>:
.globl vector6
vector6:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $6
80106781:	6a 06                	push   $0x6
  jmp alltraps
80106783:	e9 0b fb ff ff       	jmp    80106293 <alltraps>

80106788 <vector7>:
.globl vector7
vector7:
  pushl $0
80106788:	6a 00                	push   $0x0
  pushl $7
8010678a:	6a 07                	push   $0x7
  jmp alltraps
8010678c:	e9 02 fb ff ff       	jmp    80106293 <alltraps>

80106791 <vector8>:
.globl vector8
vector8:
  pushl $8
80106791:	6a 08                	push   $0x8
  jmp alltraps
80106793:	e9 fb fa ff ff       	jmp    80106293 <alltraps>

80106798 <vector9>:
.globl vector9
vector9:
  pushl $0
80106798:	6a 00                	push   $0x0
  pushl $9
8010679a:	6a 09                	push   $0x9
  jmp alltraps
8010679c:	e9 f2 fa ff ff       	jmp    80106293 <alltraps>

801067a1 <vector10>:
.globl vector10
vector10:
  pushl $10
801067a1:	6a 0a                	push   $0xa
  jmp alltraps
801067a3:	e9 eb fa ff ff       	jmp    80106293 <alltraps>

801067a8 <vector11>:
.globl vector11
vector11:
  pushl $11
801067a8:	6a 0b                	push   $0xb
  jmp alltraps
801067aa:	e9 e4 fa ff ff       	jmp    80106293 <alltraps>

801067af <vector12>:
.globl vector12
vector12:
  pushl $12
801067af:	6a 0c                	push   $0xc
  jmp alltraps
801067b1:	e9 dd fa ff ff       	jmp    80106293 <alltraps>

801067b6 <vector13>:
.globl vector13
vector13:
  pushl $13
801067b6:	6a 0d                	push   $0xd
  jmp alltraps
801067b8:	e9 d6 fa ff ff       	jmp    80106293 <alltraps>

801067bd <vector14>:
.globl vector14
vector14:
  pushl $14
801067bd:	6a 0e                	push   $0xe
  jmp alltraps
801067bf:	e9 cf fa ff ff       	jmp    80106293 <alltraps>

801067c4 <vector15>:
.globl vector15
vector15:
  pushl $0
801067c4:	6a 00                	push   $0x0
  pushl $15
801067c6:	6a 0f                	push   $0xf
  jmp alltraps
801067c8:	e9 c6 fa ff ff       	jmp    80106293 <alltraps>

801067cd <vector16>:
.globl vector16
vector16:
  pushl $0
801067cd:	6a 00                	push   $0x0
  pushl $16
801067cf:	6a 10                	push   $0x10
  jmp alltraps
801067d1:	e9 bd fa ff ff       	jmp    80106293 <alltraps>

801067d6 <vector17>:
.globl vector17
vector17:
  pushl $17
801067d6:	6a 11                	push   $0x11
  jmp alltraps
801067d8:	e9 b6 fa ff ff       	jmp    80106293 <alltraps>

801067dd <vector18>:
.globl vector18
vector18:
  pushl $0
801067dd:	6a 00                	push   $0x0
  pushl $18
801067df:	6a 12                	push   $0x12
  jmp alltraps
801067e1:	e9 ad fa ff ff       	jmp    80106293 <alltraps>

801067e6 <vector19>:
.globl vector19
vector19:
  pushl $0
801067e6:	6a 00                	push   $0x0
  pushl $19
801067e8:	6a 13                	push   $0x13
  jmp alltraps
801067ea:	e9 a4 fa ff ff       	jmp    80106293 <alltraps>

801067ef <vector20>:
.globl vector20
vector20:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $20
801067f1:	6a 14                	push   $0x14
  jmp alltraps
801067f3:	e9 9b fa ff ff       	jmp    80106293 <alltraps>

801067f8 <vector21>:
.globl vector21
vector21:
  pushl $0
801067f8:	6a 00                	push   $0x0
  pushl $21
801067fa:	6a 15                	push   $0x15
  jmp alltraps
801067fc:	e9 92 fa ff ff       	jmp    80106293 <alltraps>

80106801 <vector22>:
.globl vector22
vector22:
  pushl $0
80106801:	6a 00                	push   $0x0
  pushl $22
80106803:	6a 16                	push   $0x16
  jmp alltraps
80106805:	e9 89 fa ff ff       	jmp    80106293 <alltraps>

8010680a <vector23>:
.globl vector23
vector23:
  pushl $0
8010680a:	6a 00                	push   $0x0
  pushl $23
8010680c:	6a 17                	push   $0x17
  jmp alltraps
8010680e:	e9 80 fa ff ff       	jmp    80106293 <alltraps>

80106813 <vector24>:
.globl vector24
vector24:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $24
80106815:	6a 18                	push   $0x18
  jmp alltraps
80106817:	e9 77 fa ff ff       	jmp    80106293 <alltraps>

8010681c <vector25>:
.globl vector25
vector25:
  pushl $0
8010681c:	6a 00                	push   $0x0
  pushl $25
8010681e:	6a 19                	push   $0x19
  jmp alltraps
80106820:	e9 6e fa ff ff       	jmp    80106293 <alltraps>

80106825 <vector26>:
.globl vector26
vector26:
  pushl $0
80106825:	6a 00                	push   $0x0
  pushl $26
80106827:	6a 1a                	push   $0x1a
  jmp alltraps
80106829:	e9 65 fa ff ff       	jmp    80106293 <alltraps>

8010682e <vector27>:
.globl vector27
vector27:
  pushl $0
8010682e:	6a 00                	push   $0x0
  pushl $27
80106830:	6a 1b                	push   $0x1b
  jmp alltraps
80106832:	e9 5c fa ff ff       	jmp    80106293 <alltraps>

80106837 <vector28>:
.globl vector28
vector28:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $28
80106839:	6a 1c                	push   $0x1c
  jmp alltraps
8010683b:	e9 53 fa ff ff       	jmp    80106293 <alltraps>

80106840 <vector29>:
.globl vector29
vector29:
  pushl $0
80106840:	6a 00                	push   $0x0
  pushl $29
80106842:	6a 1d                	push   $0x1d
  jmp alltraps
80106844:	e9 4a fa ff ff       	jmp    80106293 <alltraps>

80106849 <vector30>:
.globl vector30
vector30:
  pushl $0
80106849:	6a 00                	push   $0x0
  pushl $30
8010684b:	6a 1e                	push   $0x1e
  jmp alltraps
8010684d:	e9 41 fa ff ff       	jmp    80106293 <alltraps>

80106852 <vector31>:
.globl vector31
vector31:
  pushl $0
80106852:	6a 00                	push   $0x0
  pushl $31
80106854:	6a 1f                	push   $0x1f
  jmp alltraps
80106856:	e9 38 fa ff ff       	jmp    80106293 <alltraps>

8010685b <vector32>:
.globl vector32
vector32:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $32
8010685d:	6a 20                	push   $0x20
  jmp alltraps
8010685f:	e9 2f fa ff ff       	jmp    80106293 <alltraps>

80106864 <vector33>:
.globl vector33
vector33:
  pushl $0
80106864:	6a 00                	push   $0x0
  pushl $33
80106866:	6a 21                	push   $0x21
  jmp alltraps
80106868:	e9 26 fa ff ff       	jmp    80106293 <alltraps>

8010686d <vector34>:
.globl vector34
vector34:
  pushl $0
8010686d:	6a 00                	push   $0x0
  pushl $34
8010686f:	6a 22                	push   $0x22
  jmp alltraps
80106871:	e9 1d fa ff ff       	jmp    80106293 <alltraps>

80106876 <vector35>:
.globl vector35
vector35:
  pushl $0
80106876:	6a 00                	push   $0x0
  pushl $35
80106878:	6a 23                	push   $0x23
  jmp alltraps
8010687a:	e9 14 fa ff ff       	jmp    80106293 <alltraps>

8010687f <vector36>:
.globl vector36
vector36:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $36
80106881:	6a 24                	push   $0x24
  jmp alltraps
80106883:	e9 0b fa ff ff       	jmp    80106293 <alltraps>

80106888 <vector37>:
.globl vector37
vector37:
  pushl $0
80106888:	6a 00                	push   $0x0
  pushl $37
8010688a:	6a 25                	push   $0x25
  jmp alltraps
8010688c:	e9 02 fa ff ff       	jmp    80106293 <alltraps>

80106891 <vector38>:
.globl vector38
vector38:
  pushl $0
80106891:	6a 00                	push   $0x0
  pushl $38
80106893:	6a 26                	push   $0x26
  jmp alltraps
80106895:	e9 f9 f9 ff ff       	jmp    80106293 <alltraps>

8010689a <vector39>:
.globl vector39
vector39:
  pushl $0
8010689a:	6a 00                	push   $0x0
  pushl $39
8010689c:	6a 27                	push   $0x27
  jmp alltraps
8010689e:	e9 f0 f9 ff ff       	jmp    80106293 <alltraps>

801068a3 <vector40>:
.globl vector40
vector40:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $40
801068a5:	6a 28                	push   $0x28
  jmp alltraps
801068a7:	e9 e7 f9 ff ff       	jmp    80106293 <alltraps>

801068ac <vector41>:
.globl vector41
vector41:
  pushl $0
801068ac:	6a 00                	push   $0x0
  pushl $41
801068ae:	6a 29                	push   $0x29
  jmp alltraps
801068b0:	e9 de f9 ff ff       	jmp    80106293 <alltraps>

801068b5 <vector42>:
.globl vector42
vector42:
  pushl $0
801068b5:	6a 00                	push   $0x0
  pushl $42
801068b7:	6a 2a                	push   $0x2a
  jmp alltraps
801068b9:	e9 d5 f9 ff ff       	jmp    80106293 <alltraps>

801068be <vector43>:
.globl vector43
vector43:
  pushl $0
801068be:	6a 00                	push   $0x0
  pushl $43
801068c0:	6a 2b                	push   $0x2b
  jmp alltraps
801068c2:	e9 cc f9 ff ff       	jmp    80106293 <alltraps>

801068c7 <vector44>:
.globl vector44
vector44:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $44
801068c9:	6a 2c                	push   $0x2c
  jmp alltraps
801068cb:	e9 c3 f9 ff ff       	jmp    80106293 <alltraps>

801068d0 <vector45>:
.globl vector45
vector45:
  pushl $0
801068d0:	6a 00                	push   $0x0
  pushl $45
801068d2:	6a 2d                	push   $0x2d
  jmp alltraps
801068d4:	e9 ba f9 ff ff       	jmp    80106293 <alltraps>

801068d9 <vector46>:
.globl vector46
vector46:
  pushl $0
801068d9:	6a 00                	push   $0x0
  pushl $46
801068db:	6a 2e                	push   $0x2e
  jmp alltraps
801068dd:	e9 b1 f9 ff ff       	jmp    80106293 <alltraps>

801068e2 <vector47>:
.globl vector47
vector47:
  pushl $0
801068e2:	6a 00                	push   $0x0
  pushl $47
801068e4:	6a 2f                	push   $0x2f
  jmp alltraps
801068e6:	e9 a8 f9 ff ff       	jmp    80106293 <alltraps>

801068eb <vector48>:
.globl vector48
vector48:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $48
801068ed:	6a 30                	push   $0x30
  jmp alltraps
801068ef:	e9 9f f9 ff ff       	jmp    80106293 <alltraps>

801068f4 <vector49>:
.globl vector49
vector49:
  pushl $0
801068f4:	6a 00                	push   $0x0
  pushl $49
801068f6:	6a 31                	push   $0x31
  jmp alltraps
801068f8:	e9 96 f9 ff ff       	jmp    80106293 <alltraps>

801068fd <vector50>:
.globl vector50
vector50:
  pushl $0
801068fd:	6a 00                	push   $0x0
  pushl $50
801068ff:	6a 32                	push   $0x32
  jmp alltraps
80106901:	e9 8d f9 ff ff       	jmp    80106293 <alltraps>

80106906 <vector51>:
.globl vector51
vector51:
  pushl $0
80106906:	6a 00                	push   $0x0
  pushl $51
80106908:	6a 33                	push   $0x33
  jmp alltraps
8010690a:	e9 84 f9 ff ff       	jmp    80106293 <alltraps>

8010690f <vector52>:
.globl vector52
vector52:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $52
80106911:	6a 34                	push   $0x34
  jmp alltraps
80106913:	e9 7b f9 ff ff       	jmp    80106293 <alltraps>

80106918 <vector53>:
.globl vector53
vector53:
  pushl $0
80106918:	6a 00                	push   $0x0
  pushl $53
8010691a:	6a 35                	push   $0x35
  jmp alltraps
8010691c:	e9 72 f9 ff ff       	jmp    80106293 <alltraps>

80106921 <vector54>:
.globl vector54
vector54:
  pushl $0
80106921:	6a 00                	push   $0x0
  pushl $54
80106923:	6a 36                	push   $0x36
  jmp alltraps
80106925:	e9 69 f9 ff ff       	jmp    80106293 <alltraps>

8010692a <vector55>:
.globl vector55
vector55:
  pushl $0
8010692a:	6a 00                	push   $0x0
  pushl $55
8010692c:	6a 37                	push   $0x37
  jmp alltraps
8010692e:	e9 60 f9 ff ff       	jmp    80106293 <alltraps>

80106933 <vector56>:
.globl vector56
vector56:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $56
80106935:	6a 38                	push   $0x38
  jmp alltraps
80106937:	e9 57 f9 ff ff       	jmp    80106293 <alltraps>

8010693c <vector57>:
.globl vector57
vector57:
  pushl $0
8010693c:	6a 00                	push   $0x0
  pushl $57
8010693e:	6a 39                	push   $0x39
  jmp alltraps
80106940:	e9 4e f9 ff ff       	jmp    80106293 <alltraps>

80106945 <vector58>:
.globl vector58
vector58:
  pushl $0
80106945:	6a 00                	push   $0x0
  pushl $58
80106947:	6a 3a                	push   $0x3a
  jmp alltraps
80106949:	e9 45 f9 ff ff       	jmp    80106293 <alltraps>

8010694e <vector59>:
.globl vector59
vector59:
  pushl $0
8010694e:	6a 00                	push   $0x0
  pushl $59
80106950:	6a 3b                	push   $0x3b
  jmp alltraps
80106952:	e9 3c f9 ff ff       	jmp    80106293 <alltraps>

80106957 <vector60>:
.globl vector60
vector60:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $60
80106959:	6a 3c                	push   $0x3c
  jmp alltraps
8010695b:	e9 33 f9 ff ff       	jmp    80106293 <alltraps>

80106960 <vector61>:
.globl vector61
vector61:
  pushl $0
80106960:	6a 00                	push   $0x0
  pushl $61
80106962:	6a 3d                	push   $0x3d
  jmp alltraps
80106964:	e9 2a f9 ff ff       	jmp    80106293 <alltraps>

80106969 <vector62>:
.globl vector62
vector62:
  pushl $0
80106969:	6a 00                	push   $0x0
  pushl $62
8010696b:	6a 3e                	push   $0x3e
  jmp alltraps
8010696d:	e9 21 f9 ff ff       	jmp    80106293 <alltraps>

80106972 <vector63>:
.globl vector63
vector63:
  pushl $0
80106972:	6a 00                	push   $0x0
  pushl $63
80106974:	6a 3f                	push   $0x3f
  jmp alltraps
80106976:	e9 18 f9 ff ff       	jmp    80106293 <alltraps>

8010697b <vector64>:
.globl vector64
vector64:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $64
8010697d:	6a 40                	push   $0x40
  jmp alltraps
8010697f:	e9 0f f9 ff ff       	jmp    80106293 <alltraps>

80106984 <vector65>:
.globl vector65
vector65:
  pushl $0
80106984:	6a 00                	push   $0x0
  pushl $65
80106986:	6a 41                	push   $0x41
  jmp alltraps
80106988:	e9 06 f9 ff ff       	jmp    80106293 <alltraps>

8010698d <vector66>:
.globl vector66
vector66:
  pushl $0
8010698d:	6a 00                	push   $0x0
  pushl $66
8010698f:	6a 42                	push   $0x42
  jmp alltraps
80106991:	e9 fd f8 ff ff       	jmp    80106293 <alltraps>

80106996 <vector67>:
.globl vector67
vector67:
  pushl $0
80106996:	6a 00                	push   $0x0
  pushl $67
80106998:	6a 43                	push   $0x43
  jmp alltraps
8010699a:	e9 f4 f8 ff ff       	jmp    80106293 <alltraps>

8010699f <vector68>:
.globl vector68
vector68:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $68
801069a1:	6a 44                	push   $0x44
  jmp alltraps
801069a3:	e9 eb f8 ff ff       	jmp    80106293 <alltraps>

801069a8 <vector69>:
.globl vector69
vector69:
  pushl $0
801069a8:	6a 00                	push   $0x0
  pushl $69
801069aa:	6a 45                	push   $0x45
  jmp alltraps
801069ac:	e9 e2 f8 ff ff       	jmp    80106293 <alltraps>

801069b1 <vector70>:
.globl vector70
vector70:
  pushl $0
801069b1:	6a 00                	push   $0x0
  pushl $70
801069b3:	6a 46                	push   $0x46
  jmp alltraps
801069b5:	e9 d9 f8 ff ff       	jmp    80106293 <alltraps>

801069ba <vector71>:
.globl vector71
vector71:
  pushl $0
801069ba:	6a 00                	push   $0x0
  pushl $71
801069bc:	6a 47                	push   $0x47
  jmp alltraps
801069be:	e9 d0 f8 ff ff       	jmp    80106293 <alltraps>

801069c3 <vector72>:
.globl vector72
vector72:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $72
801069c5:	6a 48                	push   $0x48
  jmp alltraps
801069c7:	e9 c7 f8 ff ff       	jmp    80106293 <alltraps>

801069cc <vector73>:
.globl vector73
vector73:
  pushl $0
801069cc:	6a 00                	push   $0x0
  pushl $73
801069ce:	6a 49                	push   $0x49
  jmp alltraps
801069d0:	e9 be f8 ff ff       	jmp    80106293 <alltraps>

801069d5 <vector74>:
.globl vector74
vector74:
  pushl $0
801069d5:	6a 00                	push   $0x0
  pushl $74
801069d7:	6a 4a                	push   $0x4a
  jmp alltraps
801069d9:	e9 b5 f8 ff ff       	jmp    80106293 <alltraps>

801069de <vector75>:
.globl vector75
vector75:
  pushl $0
801069de:	6a 00                	push   $0x0
  pushl $75
801069e0:	6a 4b                	push   $0x4b
  jmp alltraps
801069e2:	e9 ac f8 ff ff       	jmp    80106293 <alltraps>

801069e7 <vector76>:
.globl vector76
vector76:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $76
801069e9:	6a 4c                	push   $0x4c
  jmp alltraps
801069eb:	e9 a3 f8 ff ff       	jmp    80106293 <alltraps>

801069f0 <vector77>:
.globl vector77
vector77:
  pushl $0
801069f0:	6a 00                	push   $0x0
  pushl $77
801069f2:	6a 4d                	push   $0x4d
  jmp alltraps
801069f4:	e9 9a f8 ff ff       	jmp    80106293 <alltraps>

801069f9 <vector78>:
.globl vector78
vector78:
  pushl $0
801069f9:	6a 00                	push   $0x0
  pushl $78
801069fb:	6a 4e                	push   $0x4e
  jmp alltraps
801069fd:	e9 91 f8 ff ff       	jmp    80106293 <alltraps>

80106a02 <vector79>:
.globl vector79
vector79:
  pushl $0
80106a02:	6a 00                	push   $0x0
  pushl $79
80106a04:	6a 4f                	push   $0x4f
  jmp alltraps
80106a06:	e9 88 f8 ff ff       	jmp    80106293 <alltraps>

80106a0b <vector80>:
.globl vector80
vector80:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $80
80106a0d:	6a 50                	push   $0x50
  jmp alltraps
80106a0f:	e9 7f f8 ff ff       	jmp    80106293 <alltraps>

80106a14 <vector81>:
.globl vector81
vector81:
  pushl $0
80106a14:	6a 00                	push   $0x0
  pushl $81
80106a16:	6a 51                	push   $0x51
  jmp alltraps
80106a18:	e9 76 f8 ff ff       	jmp    80106293 <alltraps>

80106a1d <vector82>:
.globl vector82
vector82:
  pushl $0
80106a1d:	6a 00                	push   $0x0
  pushl $82
80106a1f:	6a 52                	push   $0x52
  jmp alltraps
80106a21:	e9 6d f8 ff ff       	jmp    80106293 <alltraps>

80106a26 <vector83>:
.globl vector83
vector83:
  pushl $0
80106a26:	6a 00                	push   $0x0
  pushl $83
80106a28:	6a 53                	push   $0x53
  jmp alltraps
80106a2a:	e9 64 f8 ff ff       	jmp    80106293 <alltraps>

80106a2f <vector84>:
.globl vector84
vector84:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $84
80106a31:	6a 54                	push   $0x54
  jmp alltraps
80106a33:	e9 5b f8 ff ff       	jmp    80106293 <alltraps>

80106a38 <vector85>:
.globl vector85
vector85:
  pushl $0
80106a38:	6a 00                	push   $0x0
  pushl $85
80106a3a:	6a 55                	push   $0x55
  jmp alltraps
80106a3c:	e9 52 f8 ff ff       	jmp    80106293 <alltraps>

80106a41 <vector86>:
.globl vector86
vector86:
  pushl $0
80106a41:	6a 00                	push   $0x0
  pushl $86
80106a43:	6a 56                	push   $0x56
  jmp alltraps
80106a45:	e9 49 f8 ff ff       	jmp    80106293 <alltraps>

80106a4a <vector87>:
.globl vector87
vector87:
  pushl $0
80106a4a:	6a 00                	push   $0x0
  pushl $87
80106a4c:	6a 57                	push   $0x57
  jmp alltraps
80106a4e:	e9 40 f8 ff ff       	jmp    80106293 <alltraps>

80106a53 <vector88>:
.globl vector88
vector88:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $88
80106a55:	6a 58                	push   $0x58
  jmp alltraps
80106a57:	e9 37 f8 ff ff       	jmp    80106293 <alltraps>

80106a5c <vector89>:
.globl vector89
vector89:
  pushl $0
80106a5c:	6a 00                	push   $0x0
  pushl $89
80106a5e:	6a 59                	push   $0x59
  jmp alltraps
80106a60:	e9 2e f8 ff ff       	jmp    80106293 <alltraps>

80106a65 <vector90>:
.globl vector90
vector90:
  pushl $0
80106a65:	6a 00                	push   $0x0
  pushl $90
80106a67:	6a 5a                	push   $0x5a
  jmp alltraps
80106a69:	e9 25 f8 ff ff       	jmp    80106293 <alltraps>

80106a6e <vector91>:
.globl vector91
vector91:
  pushl $0
80106a6e:	6a 00                	push   $0x0
  pushl $91
80106a70:	6a 5b                	push   $0x5b
  jmp alltraps
80106a72:	e9 1c f8 ff ff       	jmp    80106293 <alltraps>

80106a77 <vector92>:
.globl vector92
vector92:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $92
80106a79:	6a 5c                	push   $0x5c
  jmp alltraps
80106a7b:	e9 13 f8 ff ff       	jmp    80106293 <alltraps>

80106a80 <vector93>:
.globl vector93
vector93:
  pushl $0
80106a80:	6a 00                	push   $0x0
  pushl $93
80106a82:	6a 5d                	push   $0x5d
  jmp alltraps
80106a84:	e9 0a f8 ff ff       	jmp    80106293 <alltraps>

80106a89 <vector94>:
.globl vector94
vector94:
  pushl $0
80106a89:	6a 00                	push   $0x0
  pushl $94
80106a8b:	6a 5e                	push   $0x5e
  jmp alltraps
80106a8d:	e9 01 f8 ff ff       	jmp    80106293 <alltraps>

80106a92 <vector95>:
.globl vector95
vector95:
  pushl $0
80106a92:	6a 00                	push   $0x0
  pushl $95
80106a94:	6a 5f                	push   $0x5f
  jmp alltraps
80106a96:	e9 f8 f7 ff ff       	jmp    80106293 <alltraps>

80106a9b <vector96>:
.globl vector96
vector96:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $96
80106a9d:	6a 60                	push   $0x60
  jmp alltraps
80106a9f:	e9 ef f7 ff ff       	jmp    80106293 <alltraps>

80106aa4 <vector97>:
.globl vector97
vector97:
  pushl $0
80106aa4:	6a 00                	push   $0x0
  pushl $97
80106aa6:	6a 61                	push   $0x61
  jmp alltraps
80106aa8:	e9 e6 f7 ff ff       	jmp    80106293 <alltraps>

80106aad <vector98>:
.globl vector98
vector98:
  pushl $0
80106aad:	6a 00                	push   $0x0
  pushl $98
80106aaf:	6a 62                	push   $0x62
  jmp alltraps
80106ab1:	e9 dd f7 ff ff       	jmp    80106293 <alltraps>

80106ab6 <vector99>:
.globl vector99
vector99:
  pushl $0
80106ab6:	6a 00                	push   $0x0
  pushl $99
80106ab8:	6a 63                	push   $0x63
  jmp alltraps
80106aba:	e9 d4 f7 ff ff       	jmp    80106293 <alltraps>

80106abf <vector100>:
.globl vector100
vector100:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $100
80106ac1:	6a 64                	push   $0x64
  jmp alltraps
80106ac3:	e9 cb f7 ff ff       	jmp    80106293 <alltraps>

80106ac8 <vector101>:
.globl vector101
vector101:
  pushl $0
80106ac8:	6a 00                	push   $0x0
  pushl $101
80106aca:	6a 65                	push   $0x65
  jmp alltraps
80106acc:	e9 c2 f7 ff ff       	jmp    80106293 <alltraps>

80106ad1 <vector102>:
.globl vector102
vector102:
  pushl $0
80106ad1:	6a 00                	push   $0x0
  pushl $102
80106ad3:	6a 66                	push   $0x66
  jmp alltraps
80106ad5:	e9 b9 f7 ff ff       	jmp    80106293 <alltraps>

80106ada <vector103>:
.globl vector103
vector103:
  pushl $0
80106ada:	6a 00                	push   $0x0
  pushl $103
80106adc:	6a 67                	push   $0x67
  jmp alltraps
80106ade:	e9 b0 f7 ff ff       	jmp    80106293 <alltraps>

80106ae3 <vector104>:
.globl vector104
vector104:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $104
80106ae5:	6a 68                	push   $0x68
  jmp alltraps
80106ae7:	e9 a7 f7 ff ff       	jmp    80106293 <alltraps>

80106aec <vector105>:
.globl vector105
vector105:
  pushl $0
80106aec:	6a 00                	push   $0x0
  pushl $105
80106aee:	6a 69                	push   $0x69
  jmp alltraps
80106af0:	e9 9e f7 ff ff       	jmp    80106293 <alltraps>

80106af5 <vector106>:
.globl vector106
vector106:
  pushl $0
80106af5:	6a 00                	push   $0x0
  pushl $106
80106af7:	6a 6a                	push   $0x6a
  jmp alltraps
80106af9:	e9 95 f7 ff ff       	jmp    80106293 <alltraps>

80106afe <vector107>:
.globl vector107
vector107:
  pushl $0
80106afe:	6a 00                	push   $0x0
  pushl $107
80106b00:	6a 6b                	push   $0x6b
  jmp alltraps
80106b02:	e9 8c f7 ff ff       	jmp    80106293 <alltraps>

80106b07 <vector108>:
.globl vector108
vector108:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $108
80106b09:	6a 6c                	push   $0x6c
  jmp alltraps
80106b0b:	e9 83 f7 ff ff       	jmp    80106293 <alltraps>

80106b10 <vector109>:
.globl vector109
vector109:
  pushl $0
80106b10:	6a 00                	push   $0x0
  pushl $109
80106b12:	6a 6d                	push   $0x6d
  jmp alltraps
80106b14:	e9 7a f7 ff ff       	jmp    80106293 <alltraps>

80106b19 <vector110>:
.globl vector110
vector110:
  pushl $0
80106b19:	6a 00                	push   $0x0
  pushl $110
80106b1b:	6a 6e                	push   $0x6e
  jmp alltraps
80106b1d:	e9 71 f7 ff ff       	jmp    80106293 <alltraps>

80106b22 <vector111>:
.globl vector111
vector111:
  pushl $0
80106b22:	6a 00                	push   $0x0
  pushl $111
80106b24:	6a 6f                	push   $0x6f
  jmp alltraps
80106b26:	e9 68 f7 ff ff       	jmp    80106293 <alltraps>

80106b2b <vector112>:
.globl vector112
vector112:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $112
80106b2d:	6a 70                	push   $0x70
  jmp alltraps
80106b2f:	e9 5f f7 ff ff       	jmp    80106293 <alltraps>

80106b34 <vector113>:
.globl vector113
vector113:
  pushl $0
80106b34:	6a 00                	push   $0x0
  pushl $113
80106b36:	6a 71                	push   $0x71
  jmp alltraps
80106b38:	e9 56 f7 ff ff       	jmp    80106293 <alltraps>

80106b3d <vector114>:
.globl vector114
vector114:
  pushl $0
80106b3d:	6a 00                	push   $0x0
  pushl $114
80106b3f:	6a 72                	push   $0x72
  jmp alltraps
80106b41:	e9 4d f7 ff ff       	jmp    80106293 <alltraps>

80106b46 <vector115>:
.globl vector115
vector115:
  pushl $0
80106b46:	6a 00                	push   $0x0
  pushl $115
80106b48:	6a 73                	push   $0x73
  jmp alltraps
80106b4a:	e9 44 f7 ff ff       	jmp    80106293 <alltraps>

80106b4f <vector116>:
.globl vector116
vector116:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $116
80106b51:	6a 74                	push   $0x74
  jmp alltraps
80106b53:	e9 3b f7 ff ff       	jmp    80106293 <alltraps>

80106b58 <vector117>:
.globl vector117
vector117:
  pushl $0
80106b58:	6a 00                	push   $0x0
  pushl $117
80106b5a:	6a 75                	push   $0x75
  jmp alltraps
80106b5c:	e9 32 f7 ff ff       	jmp    80106293 <alltraps>

80106b61 <vector118>:
.globl vector118
vector118:
  pushl $0
80106b61:	6a 00                	push   $0x0
  pushl $118
80106b63:	6a 76                	push   $0x76
  jmp alltraps
80106b65:	e9 29 f7 ff ff       	jmp    80106293 <alltraps>

80106b6a <vector119>:
.globl vector119
vector119:
  pushl $0
80106b6a:	6a 00                	push   $0x0
  pushl $119
80106b6c:	6a 77                	push   $0x77
  jmp alltraps
80106b6e:	e9 20 f7 ff ff       	jmp    80106293 <alltraps>

80106b73 <vector120>:
.globl vector120
vector120:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $120
80106b75:	6a 78                	push   $0x78
  jmp alltraps
80106b77:	e9 17 f7 ff ff       	jmp    80106293 <alltraps>

80106b7c <vector121>:
.globl vector121
vector121:
  pushl $0
80106b7c:	6a 00                	push   $0x0
  pushl $121
80106b7e:	6a 79                	push   $0x79
  jmp alltraps
80106b80:	e9 0e f7 ff ff       	jmp    80106293 <alltraps>

80106b85 <vector122>:
.globl vector122
vector122:
  pushl $0
80106b85:	6a 00                	push   $0x0
  pushl $122
80106b87:	6a 7a                	push   $0x7a
  jmp alltraps
80106b89:	e9 05 f7 ff ff       	jmp    80106293 <alltraps>

80106b8e <vector123>:
.globl vector123
vector123:
  pushl $0
80106b8e:	6a 00                	push   $0x0
  pushl $123
80106b90:	6a 7b                	push   $0x7b
  jmp alltraps
80106b92:	e9 fc f6 ff ff       	jmp    80106293 <alltraps>

80106b97 <vector124>:
.globl vector124
vector124:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $124
80106b99:	6a 7c                	push   $0x7c
  jmp alltraps
80106b9b:	e9 f3 f6 ff ff       	jmp    80106293 <alltraps>

80106ba0 <vector125>:
.globl vector125
vector125:
  pushl $0
80106ba0:	6a 00                	push   $0x0
  pushl $125
80106ba2:	6a 7d                	push   $0x7d
  jmp alltraps
80106ba4:	e9 ea f6 ff ff       	jmp    80106293 <alltraps>

80106ba9 <vector126>:
.globl vector126
vector126:
  pushl $0
80106ba9:	6a 00                	push   $0x0
  pushl $126
80106bab:	6a 7e                	push   $0x7e
  jmp alltraps
80106bad:	e9 e1 f6 ff ff       	jmp    80106293 <alltraps>

80106bb2 <vector127>:
.globl vector127
vector127:
  pushl $0
80106bb2:	6a 00                	push   $0x0
  pushl $127
80106bb4:	6a 7f                	push   $0x7f
  jmp alltraps
80106bb6:	e9 d8 f6 ff ff       	jmp    80106293 <alltraps>

80106bbb <vector128>:
.globl vector128
vector128:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $128
80106bbd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106bc2:	e9 cc f6 ff ff       	jmp    80106293 <alltraps>

80106bc7 <vector129>:
.globl vector129
vector129:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $129
80106bc9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106bce:	e9 c0 f6 ff ff       	jmp    80106293 <alltraps>

80106bd3 <vector130>:
.globl vector130
vector130:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $130
80106bd5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106bda:	e9 b4 f6 ff ff       	jmp    80106293 <alltraps>

80106bdf <vector131>:
.globl vector131
vector131:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $131
80106be1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106be6:	e9 a8 f6 ff ff       	jmp    80106293 <alltraps>

80106beb <vector132>:
.globl vector132
vector132:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $132
80106bed:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106bf2:	e9 9c f6 ff ff       	jmp    80106293 <alltraps>

80106bf7 <vector133>:
.globl vector133
vector133:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $133
80106bf9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106bfe:	e9 90 f6 ff ff       	jmp    80106293 <alltraps>

80106c03 <vector134>:
.globl vector134
vector134:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $134
80106c05:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106c0a:	e9 84 f6 ff ff       	jmp    80106293 <alltraps>

80106c0f <vector135>:
.globl vector135
vector135:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $135
80106c11:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106c16:	e9 78 f6 ff ff       	jmp    80106293 <alltraps>

80106c1b <vector136>:
.globl vector136
vector136:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $136
80106c1d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106c22:	e9 6c f6 ff ff       	jmp    80106293 <alltraps>

80106c27 <vector137>:
.globl vector137
vector137:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $137
80106c29:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106c2e:	e9 60 f6 ff ff       	jmp    80106293 <alltraps>

80106c33 <vector138>:
.globl vector138
vector138:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $138
80106c35:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106c3a:	e9 54 f6 ff ff       	jmp    80106293 <alltraps>

80106c3f <vector139>:
.globl vector139
vector139:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $139
80106c41:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106c46:	e9 48 f6 ff ff       	jmp    80106293 <alltraps>

80106c4b <vector140>:
.globl vector140
vector140:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $140
80106c4d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106c52:	e9 3c f6 ff ff       	jmp    80106293 <alltraps>

80106c57 <vector141>:
.globl vector141
vector141:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $141
80106c59:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106c5e:	e9 30 f6 ff ff       	jmp    80106293 <alltraps>

80106c63 <vector142>:
.globl vector142
vector142:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $142
80106c65:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106c6a:	e9 24 f6 ff ff       	jmp    80106293 <alltraps>

80106c6f <vector143>:
.globl vector143
vector143:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $143
80106c71:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106c76:	e9 18 f6 ff ff       	jmp    80106293 <alltraps>

80106c7b <vector144>:
.globl vector144
vector144:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $144
80106c7d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106c82:	e9 0c f6 ff ff       	jmp    80106293 <alltraps>

80106c87 <vector145>:
.globl vector145
vector145:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $145
80106c89:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106c8e:	e9 00 f6 ff ff       	jmp    80106293 <alltraps>

80106c93 <vector146>:
.globl vector146
vector146:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $146
80106c95:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106c9a:	e9 f4 f5 ff ff       	jmp    80106293 <alltraps>

80106c9f <vector147>:
.globl vector147
vector147:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $147
80106ca1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106ca6:	e9 e8 f5 ff ff       	jmp    80106293 <alltraps>

80106cab <vector148>:
.globl vector148
vector148:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $148
80106cad:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106cb2:	e9 dc f5 ff ff       	jmp    80106293 <alltraps>

80106cb7 <vector149>:
.globl vector149
vector149:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $149
80106cb9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106cbe:	e9 d0 f5 ff ff       	jmp    80106293 <alltraps>

80106cc3 <vector150>:
.globl vector150
vector150:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $150
80106cc5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106cca:	e9 c4 f5 ff ff       	jmp    80106293 <alltraps>

80106ccf <vector151>:
.globl vector151
vector151:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $151
80106cd1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106cd6:	e9 b8 f5 ff ff       	jmp    80106293 <alltraps>

80106cdb <vector152>:
.globl vector152
vector152:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $152
80106cdd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106ce2:	e9 ac f5 ff ff       	jmp    80106293 <alltraps>

80106ce7 <vector153>:
.globl vector153
vector153:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $153
80106ce9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106cee:	e9 a0 f5 ff ff       	jmp    80106293 <alltraps>

80106cf3 <vector154>:
.globl vector154
vector154:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $154
80106cf5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106cfa:	e9 94 f5 ff ff       	jmp    80106293 <alltraps>

80106cff <vector155>:
.globl vector155
vector155:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $155
80106d01:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106d06:	e9 88 f5 ff ff       	jmp    80106293 <alltraps>

80106d0b <vector156>:
.globl vector156
vector156:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $156
80106d0d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106d12:	e9 7c f5 ff ff       	jmp    80106293 <alltraps>

80106d17 <vector157>:
.globl vector157
vector157:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $157
80106d19:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106d1e:	e9 70 f5 ff ff       	jmp    80106293 <alltraps>

80106d23 <vector158>:
.globl vector158
vector158:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $158
80106d25:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106d2a:	e9 64 f5 ff ff       	jmp    80106293 <alltraps>

80106d2f <vector159>:
.globl vector159
vector159:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $159
80106d31:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106d36:	e9 58 f5 ff ff       	jmp    80106293 <alltraps>

80106d3b <vector160>:
.globl vector160
vector160:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $160
80106d3d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106d42:	e9 4c f5 ff ff       	jmp    80106293 <alltraps>

80106d47 <vector161>:
.globl vector161
vector161:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $161
80106d49:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106d4e:	e9 40 f5 ff ff       	jmp    80106293 <alltraps>

80106d53 <vector162>:
.globl vector162
vector162:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $162
80106d55:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106d5a:	e9 34 f5 ff ff       	jmp    80106293 <alltraps>

80106d5f <vector163>:
.globl vector163
vector163:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $163
80106d61:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106d66:	e9 28 f5 ff ff       	jmp    80106293 <alltraps>

80106d6b <vector164>:
.globl vector164
vector164:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $164
80106d6d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106d72:	e9 1c f5 ff ff       	jmp    80106293 <alltraps>

80106d77 <vector165>:
.globl vector165
vector165:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $165
80106d79:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106d7e:	e9 10 f5 ff ff       	jmp    80106293 <alltraps>

80106d83 <vector166>:
.globl vector166
vector166:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $166
80106d85:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106d8a:	e9 04 f5 ff ff       	jmp    80106293 <alltraps>

80106d8f <vector167>:
.globl vector167
vector167:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $167
80106d91:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106d96:	e9 f8 f4 ff ff       	jmp    80106293 <alltraps>

80106d9b <vector168>:
.globl vector168
vector168:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $168
80106d9d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106da2:	e9 ec f4 ff ff       	jmp    80106293 <alltraps>

80106da7 <vector169>:
.globl vector169
vector169:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $169
80106da9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106dae:	e9 e0 f4 ff ff       	jmp    80106293 <alltraps>

80106db3 <vector170>:
.globl vector170
vector170:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $170
80106db5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106dba:	e9 d4 f4 ff ff       	jmp    80106293 <alltraps>

80106dbf <vector171>:
.globl vector171
vector171:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $171
80106dc1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106dc6:	e9 c8 f4 ff ff       	jmp    80106293 <alltraps>

80106dcb <vector172>:
.globl vector172
vector172:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $172
80106dcd:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106dd2:	e9 bc f4 ff ff       	jmp    80106293 <alltraps>

80106dd7 <vector173>:
.globl vector173
vector173:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $173
80106dd9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106dde:	e9 b0 f4 ff ff       	jmp    80106293 <alltraps>

80106de3 <vector174>:
.globl vector174
vector174:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $174
80106de5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106dea:	e9 a4 f4 ff ff       	jmp    80106293 <alltraps>

80106def <vector175>:
.globl vector175
vector175:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $175
80106df1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106df6:	e9 98 f4 ff ff       	jmp    80106293 <alltraps>

80106dfb <vector176>:
.globl vector176
vector176:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $176
80106dfd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106e02:	e9 8c f4 ff ff       	jmp    80106293 <alltraps>

80106e07 <vector177>:
.globl vector177
vector177:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $177
80106e09:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106e0e:	e9 80 f4 ff ff       	jmp    80106293 <alltraps>

80106e13 <vector178>:
.globl vector178
vector178:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $178
80106e15:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106e1a:	e9 74 f4 ff ff       	jmp    80106293 <alltraps>

80106e1f <vector179>:
.globl vector179
vector179:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $179
80106e21:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106e26:	e9 68 f4 ff ff       	jmp    80106293 <alltraps>

80106e2b <vector180>:
.globl vector180
vector180:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $180
80106e2d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106e32:	e9 5c f4 ff ff       	jmp    80106293 <alltraps>

80106e37 <vector181>:
.globl vector181
vector181:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $181
80106e39:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106e3e:	e9 50 f4 ff ff       	jmp    80106293 <alltraps>

80106e43 <vector182>:
.globl vector182
vector182:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $182
80106e45:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106e4a:	e9 44 f4 ff ff       	jmp    80106293 <alltraps>

80106e4f <vector183>:
.globl vector183
vector183:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $183
80106e51:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106e56:	e9 38 f4 ff ff       	jmp    80106293 <alltraps>

80106e5b <vector184>:
.globl vector184
vector184:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $184
80106e5d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106e62:	e9 2c f4 ff ff       	jmp    80106293 <alltraps>

80106e67 <vector185>:
.globl vector185
vector185:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $185
80106e69:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106e6e:	e9 20 f4 ff ff       	jmp    80106293 <alltraps>

80106e73 <vector186>:
.globl vector186
vector186:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $186
80106e75:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106e7a:	e9 14 f4 ff ff       	jmp    80106293 <alltraps>

80106e7f <vector187>:
.globl vector187
vector187:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $187
80106e81:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106e86:	e9 08 f4 ff ff       	jmp    80106293 <alltraps>

80106e8b <vector188>:
.globl vector188
vector188:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $188
80106e8d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106e92:	e9 fc f3 ff ff       	jmp    80106293 <alltraps>

80106e97 <vector189>:
.globl vector189
vector189:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $189
80106e99:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106e9e:	e9 f0 f3 ff ff       	jmp    80106293 <alltraps>

80106ea3 <vector190>:
.globl vector190
vector190:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $190
80106ea5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106eaa:	e9 e4 f3 ff ff       	jmp    80106293 <alltraps>

80106eaf <vector191>:
.globl vector191
vector191:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $191
80106eb1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106eb6:	e9 d8 f3 ff ff       	jmp    80106293 <alltraps>

80106ebb <vector192>:
.globl vector192
vector192:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $192
80106ebd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106ec2:	e9 cc f3 ff ff       	jmp    80106293 <alltraps>

80106ec7 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $193
80106ec9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106ece:	e9 c0 f3 ff ff       	jmp    80106293 <alltraps>

80106ed3 <vector194>:
.globl vector194
vector194:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $194
80106ed5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106eda:	e9 b4 f3 ff ff       	jmp    80106293 <alltraps>

80106edf <vector195>:
.globl vector195
vector195:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $195
80106ee1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106ee6:	e9 a8 f3 ff ff       	jmp    80106293 <alltraps>

80106eeb <vector196>:
.globl vector196
vector196:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $196
80106eed:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106ef2:	e9 9c f3 ff ff       	jmp    80106293 <alltraps>

80106ef7 <vector197>:
.globl vector197
vector197:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $197
80106ef9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106efe:	e9 90 f3 ff ff       	jmp    80106293 <alltraps>

80106f03 <vector198>:
.globl vector198
vector198:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $198
80106f05:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106f0a:	e9 84 f3 ff ff       	jmp    80106293 <alltraps>

80106f0f <vector199>:
.globl vector199
vector199:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $199
80106f11:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106f16:	e9 78 f3 ff ff       	jmp    80106293 <alltraps>

80106f1b <vector200>:
.globl vector200
vector200:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $200
80106f1d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106f22:	e9 6c f3 ff ff       	jmp    80106293 <alltraps>

80106f27 <vector201>:
.globl vector201
vector201:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $201
80106f29:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106f2e:	e9 60 f3 ff ff       	jmp    80106293 <alltraps>

80106f33 <vector202>:
.globl vector202
vector202:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $202
80106f35:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106f3a:	e9 54 f3 ff ff       	jmp    80106293 <alltraps>

80106f3f <vector203>:
.globl vector203
vector203:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $203
80106f41:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106f46:	e9 48 f3 ff ff       	jmp    80106293 <alltraps>

80106f4b <vector204>:
.globl vector204
vector204:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $204
80106f4d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106f52:	e9 3c f3 ff ff       	jmp    80106293 <alltraps>

80106f57 <vector205>:
.globl vector205
vector205:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $205
80106f59:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106f5e:	e9 30 f3 ff ff       	jmp    80106293 <alltraps>

80106f63 <vector206>:
.globl vector206
vector206:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $206
80106f65:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106f6a:	e9 24 f3 ff ff       	jmp    80106293 <alltraps>

80106f6f <vector207>:
.globl vector207
vector207:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $207
80106f71:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106f76:	e9 18 f3 ff ff       	jmp    80106293 <alltraps>

80106f7b <vector208>:
.globl vector208
vector208:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $208
80106f7d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106f82:	e9 0c f3 ff ff       	jmp    80106293 <alltraps>

80106f87 <vector209>:
.globl vector209
vector209:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $209
80106f89:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106f8e:	e9 00 f3 ff ff       	jmp    80106293 <alltraps>

80106f93 <vector210>:
.globl vector210
vector210:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $210
80106f95:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106f9a:	e9 f4 f2 ff ff       	jmp    80106293 <alltraps>

80106f9f <vector211>:
.globl vector211
vector211:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $211
80106fa1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106fa6:	e9 e8 f2 ff ff       	jmp    80106293 <alltraps>

80106fab <vector212>:
.globl vector212
vector212:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $212
80106fad:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106fb2:	e9 dc f2 ff ff       	jmp    80106293 <alltraps>

80106fb7 <vector213>:
.globl vector213
vector213:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $213
80106fb9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106fbe:	e9 d0 f2 ff ff       	jmp    80106293 <alltraps>

80106fc3 <vector214>:
.globl vector214
vector214:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $214
80106fc5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106fca:	e9 c4 f2 ff ff       	jmp    80106293 <alltraps>

80106fcf <vector215>:
.globl vector215
vector215:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $215
80106fd1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106fd6:	e9 b8 f2 ff ff       	jmp    80106293 <alltraps>

80106fdb <vector216>:
.globl vector216
vector216:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $216
80106fdd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106fe2:	e9 ac f2 ff ff       	jmp    80106293 <alltraps>

80106fe7 <vector217>:
.globl vector217
vector217:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $217
80106fe9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106fee:	e9 a0 f2 ff ff       	jmp    80106293 <alltraps>

80106ff3 <vector218>:
.globl vector218
vector218:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $218
80106ff5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106ffa:	e9 94 f2 ff ff       	jmp    80106293 <alltraps>

80106fff <vector219>:
.globl vector219
vector219:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $219
80107001:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107006:	e9 88 f2 ff ff       	jmp    80106293 <alltraps>

8010700b <vector220>:
.globl vector220
vector220:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $220
8010700d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107012:	e9 7c f2 ff ff       	jmp    80106293 <alltraps>

80107017 <vector221>:
.globl vector221
vector221:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $221
80107019:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010701e:	e9 70 f2 ff ff       	jmp    80106293 <alltraps>

80107023 <vector222>:
.globl vector222
vector222:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $222
80107025:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010702a:	e9 64 f2 ff ff       	jmp    80106293 <alltraps>

8010702f <vector223>:
.globl vector223
vector223:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $223
80107031:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107036:	e9 58 f2 ff ff       	jmp    80106293 <alltraps>

8010703b <vector224>:
.globl vector224
vector224:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $224
8010703d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107042:	e9 4c f2 ff ff       	jmp    80106293 <alltraps>

80107047 <vector225>:
.globl vector225
vector225:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $225
80107049:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010704e:	e9 40 f2 ff ff       	jmp    80106293 <alltraps>

80107053 <vector226>:
.globl vector226
vector226:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $226
80107055:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010705a:	e9 34 f2 ff ff       	jmp    80106293 <alltraps>

8010705f <vector227>:
.globl vector227
vector227:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $227
80107061:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107066:	e9 28 f2 ff ff       	jmp    80106293 <alltraps>

8010706b <vector228>:
.globl vector228
vector228:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $228
8010706d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107072:	e9 1c f2 ff ff       	jmp    80106293 <alltraps>

80107077 <vector229>:
.globl vector229
vector229:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $229
80107079:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010707e:	e9 10 f2 ff ff       	jmp    80106293 <alltraps>

80107083 <vector230>:
.globl vector230
vector230:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $230
80107085:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010708a:	e9 04 f2 ff ff       	jmp    80106293 <alltraps>

8010708f <vector231>:
.globl vector231
vector231:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $231
80107091:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107096:	e9 f8 f1 ff ff       	jmp    80106293 <alltraps>

8010709b <vector232>:
.globl vector232
vector232:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $232
8010709d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801070a2:	e9 ec f1 ff ff       	jmp    80106293 <alltraps>

801070a7 <vector233>:
.globl vector233
vector233:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $233
801070a9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801070ae:	e9 e0 f1 ff ff       	jmp    80106293 <alltraps>

801070b3 <vector234>:
.globl vector234
vector234:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $234
801070b5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801070ba:	e9 d4 f1 ff ff       	jmp    80106293 <alltraps>

801070bf <vector235>:
.globl vector235
vector235:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $235
801070c1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801070c6:	e9 c8 f1 ff ff       	jmp    80106293 <alltraps>

801070cb <vector236>:
.globl vector236
vector236:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $236
801070cd:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801070d2:	e9 bc f1 ff ff       	jmp    80106293 <alltraps>

801070d7 <vector237>:
.globl vector237
vector237:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $237
801070d9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801070de:	e9 b0 f1 ff ff       	jmp    80106293 <alltraps>

801070e3 <vector238>:
.globl vector238
vector238:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $238
801070e5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801070ea:	e9 a4 f1 ff ff       	jmp    80106293 <alltraps>

801070ef <vector239>:
.globl vector239
vector239:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $239
801070f1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801070f6:	e9 98 f1 ff ff       	jmp    80106293 <alltraps>

801070fb <vector240>:
.globl vector240
vector240:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $240
801070fd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107102:	e9 8c f1 ff ff       	jmp    80106293 <alltraps>

80107107 <vector241>:
.globl vector241
vector241:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $241
80107109:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010710e:	e9 80 f1 ff ff       	jmp    80106293 <alltraps>

80107113 <vector242>:
.globl vector242
vector242:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $242
80107115:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010711a:	e9 74 f1 ff ff       	jmp    80106293 <alltraps>

8010711f <vector243>:
.globl vector243
vector243:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $243
80107121:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107126:	e9 68 f1 ff ff       	jmp    80106293 <alltraps>

8010712b <vector244>:
.globl vector244
vector244:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $244
8010712d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107132:	e9 5c f1 ff ff       	jmp    80106293 <alltraps>

80107137 <vector245>:
.globl vector245
vector245:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $245
80107139:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010713e:	e9 50 f1 ff ff       	jmp    80106293 <alltraps>

80107143 <vector246>:
.globl vector246
vector246:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $246
80107145:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010714a:	e9 44 f1 ff ff       	jmp    80106293 <alltraps>

8010714f <vector247>:
.globl vector247
vector247:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $247
80107151:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107156:	e9 38 f1 ff ff       	jmp    80106293 <alltraps>

8010715b <vector248>:
.globl vector248
vector248:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $248
8010715d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107162:	e9 2c f1 ff ff       	jmp    80106293 <alltraps>

80107167 <vector249>:
.globl vector249
vector249:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $249
80107169:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010716e:	e9 20 f1 ff ff       	jmp    80106293 <alltraps>

80107173 <vector250>:
.globl vector250
vector250:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $250
80107175:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010717a:	e9 14 f1 ff ff       	jmp    80106293 <alltraps>

8010717f <vector251>:
.globl vector251
vector251:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $251
80107181:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107186:	e9 08 f1 ff ff       	jmp    80106293 <alltraps>

8010718b <vector252>:
.globl vector252
vector252:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $252
8010718d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107192:	e9 fc f0 ff ff       	jmp    80106293 <alltraps>

80107197 <vector253>:
.globl vector253
vector253:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $253
80107199:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010719e:	e9 f0 f0 ff ff       	jmp    80106293 <alltraps>

801071a3 <vector254>:
.globl vector254
vector254:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $254
801071a5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801071aa:	e9 e4 f0 ff ff       	jmp    80106293 <alltraps>

801071af <vector255>:
.globl vector255
vector255:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $255
801071b1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801071b6:	e9 d8 f0 ff ff       	jmp    80106293 <alltraps>
801071bb:	66 90                	xchg   %ax,%ax
801071bd:	66 90                	xchg   %ax,%ax
801071bf:	90                   	nop

801071c0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	57                   	push   %edi
801071c4:	56                   	push   %esi
801071c5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801071c7:	c1 ea 16             	shr    $0x16,%edx
{
801071ca:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801071cb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801071ce:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801071d1:	8b 1f                	mov    (%edi),%ebx
801071d3:	f6 c3 01             	test   $0x1,%bl
801071d6:	74 28                	je     80107200 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071d8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801071de:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801071e4:	89 f0                	mov    %esi,%eax
}
801071e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801071e9:	c1 e8 0a             	shr    $0xa,%eax
801071ec:	25 fc 0f 00 00       	and    $0xffc,%eax
801071f1:	01 d8                	add    %ebx,%eax
}
801071f3:	5b                   	pop    %ebx
801071f4:	5e                   	pop    %esi
801071f5:	5f                   	pop    %edi
801071f6:	5d                   	pop    %ebp
801071f7:	c3                   	ret    
801071f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ff:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107200:	85 c9                	test   %ecx,%ecx
80107202:	74 2c                	je     80107230 <walkpgdir+0x70>
80107204:	e8 77 b9 ff ff       	call   80102b80 <kalloc>
80107209:	89 c3                	mov    %eax,%ebx
8010720b:	85 c0                	test   %eax,%eax
8010720d:	74 21                	je     80107230 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010720f:	83 ec 04             	sub    $0x4,%esp
80107212:	68 00 10 00 00       	push   $0x1000
80107217:	6a 00                	push   $0x0
80107219:	50                   	push   %eax
8010721a:	e8 91 dc ff ff       	call   80104eb0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010721f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107225:	83 c4 10             	add    $0x10,%esp
80107228:	83 c8 07             	or     $0x7,%eax
8010722b:	89 07                	mov    %eax,(%edi)
8010722d:	eb b5                	jmp    801071e4 <walkpgdir+0x24>
8010722f:	90                   	nop
}
80107230:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107233:	31 c0                	xor    %eax,%eax
}
80107235:	5b                   	pop    %ebx
80107236:	5e                   	pop    %esi
80107237:	5f                   	pop    %edi
80107238:	5d                   	pop    %ebp
80107239:	c3                   	ret    
8010723a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107240 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	57                   	push   %edi
80107244:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107246:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010724a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010724b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107250:	89 d6                	mov    %edx,%esi
{
80107252:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107253:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107259:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010725c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010725f:	8b 45 08             	mov    0x8(%ebp),%eax
80107262:	29 f0                	sub    %esi,%eax
80107264:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107267:	eb 1f                	jmp    80107288 <mappages+0x48>
80107269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107270:	f6 00 01             	testb  $0x1,(%eax)
80107273:	75 45                	jne    801072ba <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107275:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107278:	83 cb 01             	or     $0x1,%ebx
8010727b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010727d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107280:	74 2e                	je     801072b0 <mappages+0x70>
      break;
    a += PGSIZE;
80107282:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107288:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010728b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107290:	89 f2                	mov    %esi,%edx
80107292:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107295:	89 f8                	mov    %edi,%eax
80107297:	e8 24 ff ff ff       	call   801071c0 <walkpgdir>
8010729c:	85 c0                	test   %eax,%eax
8010729e:	75 d0                	jne    80107270 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801072a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801072a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801072a8:	5b                   	pop    %ebx
801072a9:	5e                   	pop    %esi
801072aa:	5f                   	pop    %edi
801072ab:	5d                   	pop    %ebp
801072ac:	c3                   	ret    
801072ad:	8d 76 00             	lea    0x0(%esi),%esi
801072b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801072b3:	31 c0                	xor    %eax,%eax
}
801072b5:	5b                   	pop    %ebx
801072b6:	5e                   	pop    %esi
801072b7:	5f                   	pop    %edi
801072b8:	5d                   	pop    %ebp
801072b9:	c3                   	ret    
      panic("remap");
801072ba:	83 ec 0c             	sub    $0xc,%esp
801072bd:	68 30 84 10 80       	push   $0x80108430
801072c2:	e8 c9 90 ff ff       	call   80100390 <panic>
801072c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072ce:	66 90                	xchg   %ax,%ax

801072d0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801072d0:	55                   	push   %ebp
801072d1:	89 e5                	mov    %esp,%ebp
801072d3:	57                   	push   %edi
801072d4:	56                   	push   %esi
801072d5:	89 c6                	mov    %eax,%esi
801072d7:	53                   	push   %ebx
801072d8:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801072da:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801072e0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801072e6:	83 ec 1c             	sub    $0x1c,%esp
801072e9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801072ec:	39 da                	cmp    %ebx,%edx
801072ee:	73 5b                	jae    8010734b <deallocuvm.part.0+0x7b>
801072f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801072f3:	89 d7                	mov    %edx,%edi
801072f5:	eb 14                	jmp    8010730b <deallocuvm.part.0+0x3b>
801072f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072fe:	66 90                	xchg   %ax,%ax
80107300:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107306:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107309:	76 40                	jbe    8010734b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010730b:	31 c9                	xor    %ecx,%ecx
8010730d:	89 fa                	mov    %edi,%edx
8010730f:	89 f0                	mov    %esi,%eax
80107311:	e8 aa fe ff ff       	call   801071c0 <walkpgdir>
80107316:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107318:	85 c0                	test   %eax,%eax
8010731a:	74 44                	je     80107360 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010731c:	8b 00                	mov    (%eax),%eax
8010731e:	a8 01                	test   $0x1,%al
80107320:	74 de                	je     80107300 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107322:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107327:	74 47                	je     80107370 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107329:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010732c:	05 00 00 00 80       	add    $0x80000000,%eax
80107331:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80107337:	50                   	push   %eax
80107338:	e8 83 b6 ff ff       	call   801029c0 <kfree>
      *pte = 0;
8010733d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107343:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107346:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107349:	77 c0                	ja     8010730b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010734b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010734e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107351:	5b                   	pop    %ebx
80107352:	5e                   	pop    %esi
80107353:	5f                   	pop    %edi
80107354:	5d                   	pop    %ebp
80107355:	c3                   	ret    
80107356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010735d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107360:	89 fa                	mov    %edi,%edx
80107362:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107368:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010736e:	eb 96                	jmp    80107306 <deallocuvm.part.0+0x36>
        panic("kfree");
80107370:	83 ec 0c             	sub    $0xc,%esp
80107373:	68 66 7d 10 80       	push   $0x80107d66
80107378:	e8 13 90 ff ff       	call   80100390 <panic>
8010737d:	8d 76 00             	lea    0x0(%esi),%esi

80107380 <seginit>:
{
80107380:	f3 0f 1e fb          	endbr32 
80107384:	55                   	push   %ebp
80107385:	89 e5                	mov    %esp,%ebp
80107387:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010738a:	e8 31 cb ff ff       	call   80103ec0 <cpuid>
  pd[0] = size-1;
8010738f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107394:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010739a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010739e:	c7 80 78 3d 11 80 ff 	movl   $0xffff,-0x7feec288(%eax)
801073a5:	ff 00 00 
801073a8:	c7 80 7c 3d 11 80 00 	movl   $0xcf9a00,-0x7feec284(%eax)
801073af:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801073b2:	c7 80 80 3d 11 80 ff 	movl   $0xffff,-0x7feec280(%eax)
801073b9:	ff 00 00 
801073bc:	c7 80 84 3d 11 80 00 	movl   $0xcf9200,-0x7feec27c(%eax)
801073c3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801073c6:	c7 80 88 3d 11 80 ff 	movl   $0xffff,-0x7feec278(%eax)
801073cd:	ff 00 00 
801073d0:	c7 80 8c 3d 11 80 00 	movl   $0xcffa00,-0x7feec274(%eax)
801073d7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801073da:	c7 80 90 3d 11 80 ff 	movl   $0xffff,-0x7feec270(%eax)
801073e1:	ff 00 00 
801073e4:	c7 80 94 3d 11 80 00 	movl   $0xcff200,-0x7feec26c(%eax)
801073eb:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801073ee:	05 70 3d 11 80       	add    $0x80113d70,%eax
  pd[1] = (uint)p;
801073f3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801073f7:	c1 e8 10             	shr    $0x10,%eax
801073fa:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801073fe:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107401:	0f 01 10             	lgdtl  (%eax)
}
80107404:	c9                   	leave  
80107405:	c3                   	ret    
80107406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010740d:	8d 76 00             	lea    0x0(%esi),%esi

80107410 <switchkvm>:
{
80107410:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107414:	a1 e4 86 11 80       	mov    0x801186e4,%eax
80107419:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010741e:	0f 22 d8             	mov    %eax,%cr3
}
80107421:	c3                   	ret    
80107422:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107430 <switchuvm>:
{
80107430:	f3 0f 1e fb          	endbr32 
80107434:	55                   	push   %ebp
80107435:	89 e5                	mov    %esp,%ebp
80107437:	57                   	push   %edi
80107438:	56                   	push   %esi
80107439:	53                   	push   %ebx
8010743a:	83 ec 1c             	sub    $0x1c,%esp
8010743d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107440:	85 f6                	test   %esi,%esi
80107442:	0f 84 cb 00 00 00    	je     80107513 <switchuvm+0xe3>
  if(p->kstack == 0)
80107448:	8b 46 08             	mov    0x8(%esi),%eax
8010744b:	85 c0                	test   %eax,%eax
8010744d:	0f 84 da 00 00 00    	je     8010752d <switchuvm+0xfd>
  if(p->pgdir == 0)
80107453:	8b 46 04             	mov    0x4(%esi),%eax
80107456:	85 c0                	test   %eax,%eax
80107458:	0f 84 c2 00 00 00    	je     80107520 <switchuvm+0xf0>
  pushcli();
8010745e:	e8 3d d8 ff ff       	call   80104ca0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107463:	e8 e8 c9 ff ff       	call   80103e50 <mycpu>
80107468:	89 c3                	mov    %eax,%ebx
8010746a:	e8 e1 c9 ff ff       	call   80103e50 <mycpu>
8010746f:	89 c7                	mov    %eax,%edi
80107471:	e8 da c9 ff ff       	call   80103e50 <mycpu>
80107476:	83 c7 08             	add    $0x8,%edi
80107479:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010747c:	e8 cf c9 ff ff       	call   80103e50 <mycpu>
80107481:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107484:	ba 67 00 00 00       	mov    $0x67,%edx
80107489:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107490:	83 c0 08             	add    $0x8,%eax
80107493:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010749a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010749f:	83 c1 08             	add    $0x8,%ecx
801074a2:	c1 e8 18             	shr    $0x18,%eax
801074a5:	c1 e9 10             	shr    $0x10,%ecx
801074a8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801074ae:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801074b4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801074b9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801074c0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801074c5:	e8 86 c9 ff ff       	call   80103e50 <mycpu>
801074ca:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801074d1:	e8 7a c9 ff ff       	call   80103e50 <mycpu>
801074d6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801074da:	8b 5e 08             	mov    0x8(%esi),%ebx
801074dd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801074e3:	e8 68 c9 ff ff       	call   80103e50 <mycpu>
801074e8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801074eb:	e8 60 c9 ff ff       	call   80103e50 <mycpu>
801074f0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801074f4:	b8 28 00 00 00       	mov    $0x28,%eax
801074f9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801074fc:	8b 46 04             	mov    0x4(%esi),%eax
801074ff:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107504:	0f 22 d8             	mov    %eax,%cr3
}
80107507:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010750a:	5b                   	pop    %ebx
8010750b:	5e                   	pop    %esi
8010750c:	5f                   	pop    %edi
8010750d:	5d                   	pop    %ebp
  popcli();
8010750e:	e9 dd d7 ff ff       	jmp    80104cf0 <popcli>
    panic("switchuvm: no process");
80107513:	83 ec 0c             	sub    $0xc,%esp
80107516:	68 36 84 10 80       	push   $0x80108436
8010751b:	e8 70 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107520:	83 ec 0c             	sub    $0xc,%esp
80107523:	68 61 84 10 80       	push   $0x80108461
80107528:	e8 63 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010752d:	83 ec 0c             	sub    $0xc,%esp
80107530:	68 4c 84 10 80       	push   $0x8010844c
80107535:	e8 56 8e ff ff       	call   80100390 <panic>
8010753a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107540 <inituvm>:
{
80107540:	f3 0f 1e fb          	endbr32 
80107544:	55                   	push   %ebp
80107545:	89 e5                	mov    %esp,%ebp
80107547:	57                   	push   %edi
80107548:	56                   	push   %esi
80107549:	53                   	push   %ebx
8010754a:	83 ec 1c             	sub    $0x1c,%esp
8010754d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107550:	8b 75 10             	mov    0x10(%ebp),%esi
80107553:	8b 7d 08             	mov    0x8(%ebp),%edi
80107556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107559:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010755f:	77 4b                	ja     801075ac <inituvm+0x6c>
  mem = kalloc();
80107561:	e8 1a b6 ff ff       	call   80102b80 <kalloc>
  memset(mem, 0, PGSIZE);
80107566:	83 ec 04             	sub    $0x4,%esp
80107569:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010756e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107570:	6a 00                	push   $0x0
80107572:	50                   	push   %eax
80107573:	e8 38 d9 ff ff       	call   80104eb0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107578:	58                   	pop    %eax
80107579:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010757f:	5a                   	pop    %edx
80107580:	6a 06                	push   $0x6
80107582:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107587:	31 d2                	xor    %edx,%edx
80107589:	50                   	push   %eax
8010758a:	89 f8                	mov    %edi,%eax
8010758c:	e8 af fc ff ff       	call   80107240 <mappages>
  memmove(mem, init, sz);
80107591:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107594:	89 75 10             	mov    %esi,0x10(%ebp)
80107597:	83 c4 10             	add    $0x10,%esp
8010759a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010759d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801075a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075a3:	5b                   	pop    %ebx
801075a4:	5e                   	pop    %esi
801075a5:	5f                   	pop    %edi
801075a6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801075a7:	e9 a4 d9 ff ff       	jmp    80104f50 <memmove>
    panic("inituvm: more than a page");
801075ac:	83 ec 0c             	sub    $0xc,%esp
801075af:	68 75 84 10 80       	push   $0x80108475
801075b4:	e8 d7 8d ff ff       	call   80100390 <panic>
801075b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075c0 <loaduvm>:
{
801075c0:	f3 0f 1e fb          	endbr32 
801075c4:	55                   	push   %ebp
801075c5:	89 e5                	mov    %esp,%ebp
801075c7:	57                   	push   %edi
801075c8:	56                   	push   %esi
801075c9:	53                   	push   %ebx
801075ca:	83 ec 1c             	sub    $0x1c,%esp
801075cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801075d0:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801075d3:	a9 ff 0f 00 00       	test   $0xfff,%eax
801075d8:	0f 85 99 00 00 00    	jne    80107677 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
801075de:	01 f0                	add    %esi,%eax
801075e0:	89 f3                	mov    %esi,%ebx
801075e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801075e5:	8b 45 14             	mov    0x14(%ebp),%eax
801075e8:	01 f0                	add    %esi,%eax
801075ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801075ed:	85 f6                	test   %esi,%esi
801075ef:	75 15                	jne    80107606 <loaduvm+0x46>
801075f1:	eb 6d                	jmp    80107660 <loaduvm+0xa0>
801075f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801075f7:	90                   	nop
801075f8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801075fe:	89 f0                	mov    %esi,%eax
80107600:	29 d8                	sub    %ebx,%eax
80107602:	39 c6                	cmp    %eax,%esi
80107604:	76 5a                	jbe    80107660 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107606:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107609:	8b 45 08             	mov    0x8(%ebp),%eax
8010760c:	31 c9                	xor    %ecx,%ecx
8010760e:	29 da                	sub    %ebx,%edx
80107610:	e8 ab fb ff ff       	call   801071c0 <walkpgdir>
80107615:	85 c0                	test   %eax,%eax
80107617:	74 51                	je     8010766a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107619:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010761b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010761e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107623:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107628:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010762e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107631:	29 d9                	sub    %ebx,%ecx
80107633:	05 00 00 00 80       	add    $0x80000000,%eax
80107638:	57                   	push   %edi
80107639:	51                   	push   %ecx
8010763a:	50                   	push   %eax
8010763b:	ff 75 10             	pushl  0x10(%ebp)
8010763e:	e8 6d a9 ff ff       	call   80101fb0 <readi>
80107643:	83 c4 10             	add    $0x10,%esp
80107646:	39 f8                	cmp    %edi,%eax
80107648:	74 ae                	je     801075f8 <loaduvm+0x38>
}
8010764a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010764d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107652:	5b                   	pop    %ebx
80107653:	5e                   	pop    %esi
80107654:	5f                   	pop    %edi
80107655:	5d                   	pop    %ebp
80107656:	c3                   	ret    
80107657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010765e:	66 90                	xchg   %ax,%ax
80107660:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107663:	31 c0                	xor    %eax,%eax
}
80107665:	5b                   	pop    %ebx
80107666:	5e                   	pop    %esi
80107667:	5f                   	pop    %edi
80107668:	5d                   	pop    %ebp
80107669:	c3                   	ret    
      panic("loaduvm: address should exist");
8010766a:	83 ec 0c             	sub    $0xc,%esp
8010766d:	68 8f 84 10 80       	push   $0x8010848f
80107672:	e8 19 8d ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107677:	83 ec 0c             	sub    $0xc,%esp
8010767a:	68 30 85 10 80       	push   $0x80108530
8010767f:	e8 0c 8d ff ff       	call   80100390 <panic>
80107684:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010768b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010768f:	90                   	nop

80107690 <allocuvm>:
{
80107690:	f3 0f 1e fb          	endbr32 
80107694:	55                   	push   %ebp
80107695:	89 e5                	mov    %esp,%ebp
80107697:	57                   	push   %edi
80107698:	56                   	push   %esi
80107699:	53                   	push   %ebx
8010769a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010769d:	8b 45 10             	mov    0x10(%ebp),%eax
{
801076a0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801076a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801076a6:	85 c0                	test   %eax,%eax
801076a8:	0f 88 b2 00 00 00    	js     80107760 <allocuvm+0xd0>
  if(newsz < oldsz)
801076ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801076b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801076b4:	0f 82 96 00 00 00    	jb     80107750 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801076ba:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801076c0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801076c6:	39 75 10             	cmp    %esi,0x10(%ebp)
801076c9:	77 40                	ja     8010770b <allocuvm+0x7b>
801076cb:	e9 83 00 00 00       	jmp    80107753 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
801076d0:	83 ec 04             	sub    $0x4,%esp
801076d3:	68 00 10 00 00       	push   $0x1000
801076d8:	6a 00                	push   $0x0
801076da:	50                   	push   %eax
801076db:	e8 d0 d7 ff ff       	call   80104eb0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801076e0:	58                   	pop    %eax
801076e1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801076e7:	5a                   	pop    %edx
801076e8:	6a 06                	push   $0x6
801076ea:	b9 00 10 00 00       	mov    $0x1000,%ecx
801076ef:	89 f2                	mov    %esi,%edx
801076f1:	50                   	push   %eax
801076f2:	89 f8                	mov    %edi,%eax
801076f4:	e8 47 fb ff ff       	call   80107240 <mappages>
801076f9:	83 c4 10             	add    $0x10,%esp
801076fc:	85 c0                	test   %eax,%eax
801076fe:	78 78                	js     80107778 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107700:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107706:	39 75 10             	cmp    %esi,0x10(%ebp)
80107709:	76 48                	jbe    80107753 <allocuvm+0xc3>
    mem = kalloc();
8010770b:	e8 70 b4 ff ff       	call   80102b80 <kalloc>
80107710:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107712:	85 c0                	test   %eax,%eax
80107714:	75 ba                	jne    801076d0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107716:	83 ec 0c             	sub    $0xc,%esp
80107719:	68 ad 84 10 80       	push   $0x801084ad
8010771e:	e8 8d 8f ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107723:	8b 45 0c             	mov    0xc(%ebp),%eax
80107726:	83 c4 10             	add    $0x10,%esp
80107729:	39 45 10             	cmp    %eax,0x10(%ebp)
8010772c:	74 32                	je     80107760 <allocuvm+0xd0>
8010772e:	8b 55 10             	mov    0x10(%ebp),%edx
80107731:	89 c1                	mov    %eax,%ecx
80107733:	89 f8                	mov    %edi,%eax
80107735:	e8 96 fb ff ff       	call   801072d0 <deallocuvm.part.0>
      return 0;
8010773a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107741:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107744:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107747:	5b                   	pop    %ebx
80107748:	5e                   	pop    %esi
80107749:	5f                   	pop    %edi
8010774a:	5d                   	pop    %ebp
8010774b:	c3                   	ret    
8010774c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107750:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107753:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107756:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107759:	5b                   	pop    %ebx
8010775a:	5e                   	pop    %esi
8010775b:	5f                   	pop    %edi
8010775c:	5d                   	pop    %ebp
8010775d:	c3                   	ret    
8010775e:	66 90                	xchg   %ax,%ax
    return 0;
80107760:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107767:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010776a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010776d:	5b                   	pop    %ebx
8010776e:	5e                   	pop    %esi
8010776f:	5f                   	pop    %edi
80107770:	5d                   	pop    %ebp
80107771:	c3                   	ret    
80107772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107778:	83 ec 0c             	sub    $0xc,%esp
8010777b:	68 c5 84 10 80       	push   $0x801084c5
80107780:	e8 2b 8f ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107785:	8b 45 0c             	mov    0xc(%ebp),%eax
80107788:	83 c4 10             	add    $0x10,%esp
8010778b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010778e:	74 0c                	je     8010779c <allocuvm+0x10c>
80107790:	8b 55 10             	mov    0x10(%ebp),%edx
80107793:	89 c1                	mov    %eax,%ecx
80107795:	89 f8                	mov    %edi,%eax
80107797:	e8 34 fb ff ff       	call   801072d0 <deallocuvm.part.0>
      kfree(mem);
8010779c:	83 ec 0c             	sub    $0xc,%esp
8010779f:	53                   	push   %ebx
801077a0:	e8 1b b2 ff ff       	call   801029c0 <kfree>
      return 0;
801077a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801077ac:	83 c4 10             	add    $0x10,%esp
}
801077af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077b5:	5b                   	pop    %ebx
801077b6:	5e                   	pop    %esi
801077b7:	5f                   	pop    %edi
801077b8:	5d                   	pop    %ebp
801077b9:	c3                   	ret    
801077ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801077c0 <deallocuvm>:
{
801077c0:	f3 0f 1e fb          	endbr32 
801077c4:	55                   	push   %ebp
801077c5:	89 e5                	mov    %esp,%ebp
801077c7:	8b 55 0c             	mov    0xc(%ebp),%edx
801077ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
801077cd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801077d0:	39 d1                	cmp    %edx,%ecx
801077d2:	73 0c                	jae    801077e0 <deallocuvm+0x20>
}
801077d4:	5d                   	pop    %ebp
801077d5:	e9 f6 fa ff ff       	jmp    801072d0 <deallocuvm.part.0>
801077da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801077e0:	89 d0                	mov    %edx,%eax
801077e2:	5d                   	pop    %ebp
801077e3:	c3                   	ret    
801077e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077ef:	90                   	nop

801077f0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801077f0:	f3 0f 1e fb          	endbr32 
801077f4:	55                   	push   %ebp
801077f5:	89 e5                	mov    %esp,%ebp
801077f7:	57                   	push   %edi
801077f8:	56                   	push   %esi
801077f9:	53                   	push   %ebx
801077fa:	83 ec 0c             	sub    $0xc,%esp
801077fd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107800:	85 f6                	test   %esi,%esi
80107802:	74 55                	je     80107859 <freevm+0x69>
  if(newsz >= oldsz)
80107804:	31 c9                	xor    %ecx,%ecx
80107806:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010780b:	89 f0                	mov    %esi,%eax
8010780d:	89 f3                	mov    %esi,%ebx
8010780f:	e8 bc fa ff ff       	call   801072d0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107814:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010781a:	eb 0b                	jmp    80107827 <freevm+0x37>
8010781c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107820:	83 c3 04             	add    $0x4,%ebx
80107823:	39 df                	cmp    %ebx,%edi
80107825:	74 23                	je     8010784a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107827:	8b 03                	mov    (%ebx),%eax
80107829:	a8 01                	test   $0x1,%al
8010782b:	74 f3                	je     80107820 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010782d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107832:	83 ec 0c             	sub    $0xc,%esp
80107835:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107838:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010783d:	50                   	push   %eax
8010783e:	e8 7d b1 ff ff       	call   801029c0 <kfree>
80107843:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107846:	39 df                	cmp    %ebx,%edi
80107848:	75 dd                	jne    80107827 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010784a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010784d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107850:	5b                   	pop    %ebx
80107851:	5e                   	pop    %esi
80107852:	5f                   	pop    %edi
80107853:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107854:	e9 67 b1 ff ff       	jmp    801029c0 <kfree>
    panic("freevm: no pgdir");
80107859:	83 ec 0c             	sub    $0xc,%esp
8010785c:	68 e1 84 10 80       	push   $0x801084e1
80107861:	e8 2a 8b ff ff       	call   80100390 <panic>
80107866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010786d:	8d 76 00             	lea    0x0(%esi),%esi

80107870 <setupkvm>:
{
80107870:	f3 0f 1e fb          	endbr32 
80107874:	55                   	push   %ebp
80107875:	89 e5                	mov    %esp,%ebp
80107877:	56                   	push   %esi
80107878:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107879:	e8 02 b3 ff ff       	call   80102b80 <kalloc>
8010787e:	89 c6                	mov    %eax,%esi
80107880:	85 c0                	test   %eax,%eax
80107882:	74 42                	je     801078c6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107884:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107887:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010788c:	68 00 10 00 00       	push   $0x1000
80107891:	6a 00                	push   $0x0
80107893:	50                   	push   %eax
80107894:	e8 17 d6 ff ff       	call   80104eb0 <memset>
80107899:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010789c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010789f:	83 ec 08             	sub    $0x8,%esp
801078a2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801078a5:	ff 73 0c             	pushl  0xc(%ebx)
801078a8:	8b 13                	mov    (%ebx),%edx
801078aa:	50                   	push   %eax
801078ab:	29 c1                	sub    %eax,%ecx
801078ad:	89 f0                	mov    %esi,%eax
801078af:	e8 8c f9 ff ff       	call   80107240 <mappages>
801078b4:	83 c4 10             	add    $0x10,%esp
801078b7:	85 c0                	test   %eax,%eax
801078b9:	78 15                	js     801078d0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801078bb:	83 c3 10             	add    $0x10,%ebx
801078be:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801078c4:	75 d6                	jne    8010789c <setupkvm+0x2c>
}
801078c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801078c9:	89 f0                	mov    %esi,%eax
801078cb:	5b                   	pop    %ebx
801078cc:	5e                   	pop    %esi
801078cd:	5d                   	pop    %ebp
801078ce:	c3                   	ret    
801078cf:	90                   	nop
      freevm(pgdir);
801078d0:	83 ec 0c             	sub    $0xc,%esp
801078d3:	56                   	push   %esi
      return 0;
801078d4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801078d6:	e8 15 ff ff ff       	call   801077f0 <freevm>
      return 0;
801078db:	83 c4 10             	add    $0x10,%esp
}
801078de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801078e1:	89 f0                	mov    %esi,%eax
801078e3:	5b                   	pop    %ebx
801078e4:	5e                   	pop    %esi
801078e5:	5d                   	pop    %ebp
801078e6:	c3                   	ret    
801078e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078ee:	66 90                	xchg   %ax,%ax

801078f0 <kvmalloc>:
{
801078f0:	f3 0f 1e fb          	endbr32 
801078f4:	55                   	push   %ebp
801078f5:	89 e5                	mov    %esp,%ebp
801078f7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801078fa:	e8 71 ff ff ff       	call   80107870 <setupkvm>
801078ff:	a3 e4 86 11 80       	mov    %eax,0x801186e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107904:	05 00 00 00 80       	add    $0x80000000,%eax
80107909:	0f 22 d8             	mov    %eax,%cr3
}
8010790c:	c9                   	leave  
8010790d:	c3                   	ret    
8010790e:	66 90                	xchg   %ax,%ax

80107910 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107910:	f3 0f 1e fb          	endbr32 
80107914:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107915:	31 c9                	xor    %ecx,%ecx
{
80107917:	89 e5                	mov    %esp,%ebp
80107919:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010791c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010791f:	8b 45 08             	mov    0x8(%ebp),%eax
80107922:	e8 99 f8 ff ff       	call   801071c0 <walkpgdir>
  if(pte == 0)
80107927:	85 c0                	test   %eax,%eax
80107929:	74 05                	je     80107930 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010792b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010792e:	c9                   	leave  
8010792f:	c3                   	ret    
    panic("clearpteu");
80107930:	83 ec 0c             	sub    $0xc,%esp
80107933:	68 f2 84 10 80       	push   $0x801084f2
80107938:	e8 53 8a ff ff       	call   80100390 <panic>
8010793d:	8d 76 00             	lea    0x0(%esi),%esi

80107940 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107940:	f3 0f 1e fb          	endbr32 
80107944:	55                   	push   %ebp
80107945:	89 e5                	mov    %esp,%ebp
80107947:	57                   	push   %edi
80107948:	56                   	push   %esi
80107949:	53                   	push   %ebx
8010794a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010794d:	e8 1e ff ff ff       	call   80107870 <setupkvm>
80107952:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107955:	85 c0                	test   %eax,%eax
80107957:	0f 84 9b 00 00 00    	je     801079f8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010795d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107960:	85 c9                	test   %ecx,%ecx
80107962:	0f 84 90 00 00 00    	je     801079f8 <copyuvm+0xb8>
80107968:	31 f6                	xor    %esi,%esi
8010796a:	eb 46                	jmp    801079b2 <copyuvm+0x72>
8010796c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107970:	83 ec 04             	sub    $0x4,%esp
80107973:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107979:	68 00 10 00 00       	push   $0x1000
8010797e:	57                   	push   %edi
8010797f:	50                   	push   %eax
80107980:	e8 cb d5 ff ff       	call   80104f50 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107985:	58                   	pop    %eax
80107986:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010798c:	5a                   	pop    %edx
8010798d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107990:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107995:	89 f2                	mov    %esi,%edx
80107997:	50                   	push   %eax
80107998:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010799b:	e8 a0 f8 ff ff       	call   80107240 <mappages>
801079a0:	83 c4 10             	add    $0x10,%esp
801079a3:	85 c0                	test   %eax,%eax
801079a5:	78 61                	js     80107a08 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801079a7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801079ad:	39 75 0c             	cmp    %esi,0xc(%ebp)
801079b0:	76 46                	jbe    801079f8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801079b2:	8b 45 08             	mov    0x8(%ebp),%eax
801079b5:	31 c9                	xor    %ecx,%ecx
801079b7:	89 f2                	mov    %esi,%edx
801079b9:	e8 02 f8 ff ff       	call   801071c0 <walkpgdir>
801079be:	85 c0                	test   %eax,%eax
801079c0:	74 61                	je     80107a23 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801079c2:	8b 00                	mov    (%eax),%eax
801079c4:	a8 01                	test   $0x1,%al
801079c6:	74 4e                	je     80107a16 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801079c8:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801079ca:	25 ff 0f 00 00       	and    $0xfff,%eax
801079cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801079d2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801079d8:	e8 a3 b1 ff ff       	call   80102b80 <kalloc>
801079dd:	89 c3                	mov    %eax,%ebx
801079df:	85 c0                	test   %eax,%eax
801079e1:	75 8d                	jne    80107970 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801079e3:	83 ec 0c             	sub    $0xc,%esp
801079e6:	ff 75 e0             	pushl  -0x20(%ebp)
801079e9:	e8 02 fe ff ff       	call   801077f0 <freevm>
  return 0;
801079ee:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801079f5:	83 c4 10             	add    $0x10,%esp
}
801079f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801079fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079fe:	5b                   	pop    %ebx
801079ff:	5e                   	pop    %esi
80107a00:	5f                   	pop    %edi
80107a01:	5d                   	pop    %ebp
80107a02:	c3                   	ret    
80107a03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a07:	90                   	nop
      kfree(mem);
80107a08:	83 ec 0c             	sub    $0xc,%esp
80107a0b:	53                   	push   %ebx
80107a0c:	e8 af af ff ff       	call   801029c0 <kfree>
      goto bad;
80107a11:	83 c4 10             	add    $0x10,%esp
80107a14:	eb cd                	jmp    801079e3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107a16:	83 ec 0c             	sub    $0xc,%esp
80107a19:	68 16 85 10 80       	push   $0x80108516
80107a1e:	e8 6d 89 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107a23:	83 ec 0c             	sub    $0xc,%esp
80107a26:	68 fc 84 10 80       	push   $0x801084fc
80107a2b:	e8 60 89 ff ff       	call   80100390 <panic>

80107a30 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107a30:	f3 0f 1e fb          	endbr32 
80107a34:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107a35:	31 c9                	xor    %ecx,%ecx
{
80107a37:	89 e5                	mov    %esp,%ebp
80107a39:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a3f:	8b 45 08             	mov    0x8(%ebp),%eax
80107a42:	e8 79 f7 ff ff       	call   801071c0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107a47:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107a49:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107a4a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107a4c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107a51:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107a54:	05 00 00 00 80       	add    $0x80000000,%eax
80107a59:	83 fa 05             	cmp    $0x5,%edx
80107a5c:	ba 00 00 00 00       	mov    $0x0,%edx
80107a61:	0f 45 c2             	cmovne %edx,%eax
}
80107a64:	c3                   	ret    
80107a65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107a70 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107a70:	f3 0f 1e fb          	endbr32 
80107a74:	55                   	push   %ebp
80107a75:	89 e5                	mov    %esp,%ebp
80107a77:	57                   	push   %edi
80107a78:	56                   	push   %esi
80107a79:	53                   	push   %ebx
80107a7a:	83 ec 0c             	sub    $0xc,%esp
80107a7d:	8b 75 14             	mov    0x14(%ebp),%esi
80107a80:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107a83:	85 f6                	test   %esi,%esi
80107a85:	75 3c                	jne    80107ac3 <copyout+0x53>
80107a87:	eb 67                	jmp    80107af0 <copyout+0x80>
80107a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107a90:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a93:	89 fb                	mov    %edi,%ebx
80107a95:	29 d3                	sub    %edx,%ebx
80107a97:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107a9d:	39 f3                	cmp    %esi,%ebx
80107a9f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107aa2:	29 fa                	sub    %edi,%edx
80107aa4:	83 ec 04             	sub    $0x4,%esp
80107aa7:	01 c2                	add    %eax,%edx
80107aa9:	53                   	push   %ebx
80107aaa:	ff 75 10             	pushl  0x10(%ebp)
80107aad:	52                   	push   %edx
80107aae:	e8 9d d4 ff ff       	call   80104f50 <memmove>
    len -= n;
    buf += n;
80107ab3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107ab6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107abc:	83 c4 10             	add    $0x10,%esp
80107abf:	29 de                	sub    %ebx,%esi
80107ac1:	74 2d                	je     80107af0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107ac3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107ac5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107ac8:	89 55 0c             	mov    %edx,0xc(%ebp)
80107acb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107ad1:	57                   	push   %edi
80107ad2:	ff 75 08             	pushl  0x8(%ebp)
80107ad5:	e8 56 ff ff ff       	call   80107a30 <uva2ka>
    if(pa0 == 0)
80107ada:	83 c4 10             	add    $0x10,%esp
80107add:	85 c0                	test   %eax,%eax
80107adf:	75 af                	jne    80107a90 <copyout+0x20>
  }
  return 0;
}
80107ae1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107ae4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107ae9:	5b                   	pop    %ebx
80107aea:	5e                   	pop    %esi
80107aeb:	5f                   	pop    %edi
80107aec:	5d                   	pop    %ebp
80107aed:	c3                   	ret    
80107aee:	66 90                	xchg   %ax,%ax
80107af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107af3:	31 c0                	xor    %eax,%eax
}
80107af5:	5b                   	pop    %ebx
80107af6:	5e                   	pop    %esi
80107af7:	5f                   	pop    %edi
80107af8:	5d                   	pop    %ebp
80107af9:	c3                   	ret    
