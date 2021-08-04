

## Controller

```java
    @ResponseBody
    @GetMapping("/request-param")
    public String requestParam(
        @RequestParam("username")  String memberName,
        @RequestParam("age") int memberAge
    ){
        log.info("username ={}, age={}",memberName, memberAge);

        return "ok";
    }
```