//
//  AuthViewController.m
//  Encrypted Messenger
//
//  Created by Yongyang Nie on 5/4/17.
//  Copyright © 2017 Yongyang Nie. All rights reserved.
//

#import "AuthViewController.h"

@interface AuthViewController ()

@end

@implementation AuthViewController

-(void)textFieldDidBeginEditing:(MDTextField *)textField{
    NSLog(@"%i", self.password.secureTextEntry);
}

#pragma mark - IBActions

-(IBAction)registerUser:(id)sender{
    
    [[FIRAuth auth] createUserWithEmail:self.email.text password:self.password.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            [self showErrorAlert:error];
        }else{
            [self presentMainView];
        }
    }];
}

-(IBAction)loginUser:(id)sender{
    
    [[FIRAuth auth] signInWithEmail:self.email.text password:self.password.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            [self showErrorAlert:error];
        }else{
            [self presentMainView];
        }
    }];
    
}

-(IBAction)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

-(void)showErrorAlert:(NSError *)error{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Opps, something went wrong" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)presentMainView{
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"mainviewcontroller"];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.username.highlightColor = [UIColor grayColor];
    self.password.highlightColor = [UIColor grayColor];
    self.email.highlightColor = [UIColor grayColor];
    [self.password setSecureTextEntry:YES];
    self.password.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end