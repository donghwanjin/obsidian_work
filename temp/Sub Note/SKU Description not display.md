---
type: note
---

[[How OI display string.canvas|How OI display string]]

```c
  OI_STR_TYPE SkuImageUrl = "";
  OI_STR_TYPE SkuDescription = "";
  REC_NO ProdRecNo;
  REC_NO SkuRecNo;

  LOOP_ALL_PRODS
  {
    if( PROD_GetProdState( ProdRecNo ) == PROD_STATE_COMPLETE )
    {    
      SkuRecNo = PROD_GetSkuRecNo( ProdRecNo );
      ST_Copy( SkuImageUrl, SKU_GetImageUrl( SkuRecNo ), sizeof( SkuImageUrl ) );
      ST_Copy( SkuDescription, SKU_GetDescription( SkuRecNo ), sizeof( SkuDescription ) );
      printf("%s, %d, %s\n", SKU_GetSkuId( SkuRecNo ), ST_IsEmpty( SkuImageUrl ), SkuDescription);
    }
  }
```

result : all sku true and printed description.

~~Requested Remote Desktop Connection for specific PC~~
we can use OI screen observe mode

![[Pasted image 20240621085511.png]]
some of Korean encoding value 266 and prompt function delete it. and it caused skipping whole description.


