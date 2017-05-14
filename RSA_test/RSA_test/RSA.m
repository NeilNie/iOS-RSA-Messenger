//
//  RSA.m
//  RSA Console
//
//  Created by Yongyang Nie on 5/1/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "RSA.h"

@interface RSA ()

@end

@implementation RSA

#pragma mark - Constructor

- (instancetype)init
{
    self = [super init];
    if (self) {

        self.smallPrimes = [NSArray arrayWithObjects:@2, @3, @5, @7, @11, @13, @17, @19, @23, @29, @31, @37, @41, @43, @47, @53, @59, @61, @67, @71, @73, @79, @83, @89, @97, @101, nil];
    }
    return self;
}

#pragma mark - Encrypt/Decrypt string

/*-(NSDictionary *)prepareForEncryption{
    
    BigInteger *p = [RSA randomPrime];
    BigInteger *q = [RSA randomPrime];
    BigInteger *n = [p multiply:q];
    BigInteger *phiN = [[p subtract:[[BigInteger alloc] initWithString:@"1"]] multiply:[q subtract:[[BigInteger alloc] initWithString:@"1"]]];
    BigInteger *e = [self findeWithPhi:phiN];;
    long long d = [self modInverse:[e.stringValue longLongValue] m:[phiN.stringValue longLongValue]];
    BigInteger *privateKey = [[BigInteger alloc] initWithString:[NSString stringWithFormat:@"%lli", d]];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:p.stringValue forKey:@"p"];
    [ud setObject:q.stringValue forKey:@"q"];
    [ud setObject:n.stringValue forKey:@"n"];
    [ud setObject:phiN.stringValue forKey:@"phiN"];
    [ud setObject:privateKey.stringValue forKey:@"key"];
    [ud synchronize];
    
    return @{@"n": n.stringValue,
             @"e": e.stringValue};
    
}*/

-(NSMutableArray <NSString *> *)encryptString:(NSString *)string withPublicKey:(NSString *)key{
    
    BigInteger *e = [[BigInteger alloc] initWithString:key];
    BigInteger *n = [[BigInteger alloc] initWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"n"]];
    
    //m * e mod n
    NSMutableArray *nums = [self intRepresentation:string];
    NSMutableArray *content = [NSMutableArray array];
    for (NSNumber *num in nums) {
        BigInteger *m = [[BigInteger alloc] initWithString:[num stringValue]];
        BigInteger *val = [m pow:e andMod:n];
        [content addObject:val.stringValue];
    }
    return content;
}


-(NSString *)decryptString:(NSString *)string withPrivateKey:(NSString *)key{
    return nil;
}

#pragma mark - Encrypt/Decrypt data

-(NSData *)encryptData:(NSData *)data withPublicKey:(NSString *)key{
    return nil;
}
-(NSData *)decryptData:(NSData *)data withPrivateKey:(NSString *)key{
    return nil;
}

#pragma Int / String

-(NSMutableArray<NSNumber *> *)intRepresentation:(NSString *)string{
    
    NSMutableArray *ints = [NSMutableArray array];
    
    for (int i = 0; i < string.length; i+=4) {
        NSString *sum = @"";
        
        if (i+4 >= string.length) {
            for (int x = i; x < string.length; x++) {
                NSString *n = [self charToInt:[NSString stringWithFormat:@"%c", [string characterAtIndex:x]]];
                sum = [sum stringByAppendingString:n];
            }
        }else{
            for (int x = i; x < i+4; x++) {
                NSString *n = [self charToInt:[NSString stringWithFormat:@"%c", [string characterAtIndex:x]]];
                sum = [sum stringByAppendingString:n];
            }
        }
        
        NSMutableString *s = [NSMutableString stringWithString:sum];
        [s insertString:@"1" atIndex:0];
        sum = s;
        [ints addObject:[NSNumber numberWithLongLong:[sum longLongValue]]];
    }
    return ints;
}

-(NSString *)stringRepresentation:(NSMutableArray<NSString *> *)nums{
    
    NSString *str = @"";
    for (int i = 0; i < nums.count; i++) {
        NSMutableString *s = [NSMutableString stringWithString:nums[i]];
        [s replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
        for (int x = 0; x < s.length; x=x+2) {
            int i = [[s substringWithRange:NSMakeRange(x, 2)] intValue];
            str = [str stringByAppendingString:[self intToChar:i]];
        }
    }
    return str;
}

-(NSString *)charToInt:(NSString *)chr{
    NSArray *chrs = [@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 ~ ! @ # $ % ^ & * ( ) _ - = + { } | : \\ \" < > ? ` [ ] ; ' , . / " componentsSeparatedByString:@" "];
    NSMutableString *val = [NSMutableString stringWithFormat:@"%i", (int)[chrs indexOfObject:chr]];
    if (val.length == 1)
        [val insertString:@"0" atIndex:0];
    return val;
}

-(NSString *)intToChar:(int)index{
    NSArray *chrs = [@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 ~ ! @ # $ % ^ & * ( ) _ - = + { } | : \\ \" < > ? ` [ ] ; ' , . / " componentsSeparatedByString:@" "];
    return [chrs objectAtIndex:index];
}



#pragma mark - Private
//http://www.geeksforgeeks.org/multiplicative-inverse-under-modulo-m/
+(BigInteger *) modInverse:(BigInteger *)a m:(BigInteger *)m{
    
    BigInteger *m0 = [[BigInteger alloc] initWithString:m.stringValue];
    BigInteger *t = [[BigInteger alloc] init];
    BigInteger *q = [[BigInteger alloc] init];
    
    BigInteger *x0 = [[BigInteger alloc] initWithString:@"0"];
    BigInteger *x1 = [[BigInteger alloc] initWithString:@"1"];
    
    while ([a.stringValue longLongValue] > 1){
        // q is quotient
        q = [a divide:m];
        t = [[BigInteger alloc] initWithString:m.stringValue];
        
        // m is remainder now, process same as
        // Euclid's algo
        m = [a pow:[[BigInteger alloc] initWithString:@"1"] andMod:m];
        a = [[BigInteger alloc] initWithString:t.stringValue];
        
        t = [[BigInteger alloc] initWithString:x0.stringValue];
        BigInteger *j = [q multiply:x0];
        x0 = [x1 subtract:j];
        x1 = [[BigInteger alloc] initWithString:t.stringValue];
    }
    
    // Make x1 positive
    if ([x1.stringValue longLongValue] < 0)
        x1 = [x1 add:m0];
    
    return x1;
}

-(long long) ModInverse:(long long)a m:(long long)m{
    
    long m0 = m, t, q;
    long x0 = 0, x1 = 1;
    
    while (a > 1){
        // q is quotient
        q = a / m;
        t = m;
        
        // m is remainder now, process same as
        // Euclid's algo
        m = a % m, a = t;
        
        t = x0;
        x0 = x1 - q * x0;
        x1 = t;
    }
    
    // Make x1 positive
    if (x1 < 0)
        x1 += m0;
    
    return x1;
}

-(BigInteger *)findeWithPhi:(BigInteger *)phi{
    
    BigInteger *gcd = [[BigInteger alloc] initWithString:@"0"];
    int index = (int)self.smallPrimes.count - 1;
    while (![gcd.stringValue isEqualToString:@"1"]) {
        gcd = [phi gcd:[[BigInteger alloc] initWithString:[(NSNumber *)self.smallPrimes[index] stringValue]]];
        index--;
    }
    return [[BigInteger alloc] initWithString:[(NSNumber *)self.smallPrimes[index] stringValue]];
}

-(BigInteger *)generateE:(BigInteger *)phiN{
    return nil;
}

-(int)GCD:(int) x and: (int)y{
    
    //the greatest common divisor of y and the remainder of x divided by y.
    if (x % y == 0) {
        return y;
    }else{
        return [self GCD:y and:x % y];
    }
}

+(BigInteger *)randomPrime{
    
    NSString *string = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"primes" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray *primes = [string componentsSeparatedByString:@"\n"];

    int index = arc4random()%primes.count-1;
    NSString *value = [primes objectAtIndex:index];
    BigInteger *bi = [[BigInteger alloc] initWithString:value];
    return bi;
}

@end
