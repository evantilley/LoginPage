//
//  ContentView.swift
//  login
//
//  Created by Evan Tilley on 12/28/19.
//  Copyright © 2019 Evan Tilley. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct ContentView: View {
    @State var  status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    var body: some View {
        VStack{
            if status{
                Home()
            } else{
                Login()
            }
        }.animation(.spring())
            .onAppear{
                NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main){
                    (_) in
                    
                    let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                    self.status = status
                    
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Login: View{
    @State var user = ""
    @State var pass = ""
    @State var msg = ""
    @State var alert = false
    
    var body: some View{
        VStack{
            Image("img")
            
            Text("Sign In")
                .fontWeight(.heavy)
                .font(.largeTitle)
                .padding([.top, .bottom], 20)
            
            VStack(alignment: .leading){
                VStack(alignment: .leading){
                    Text("Username")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(Color.init(.label).opacity(0.75))
                        HStack{
                            
                            TextField("Enter Your Username", text: $user)
                            .foregroundColor(Color.init(.label))
                            
                        }
                        
                        Divider()
                }.padding(.bottom, 15)
                VStack(alignment: .leading){
                        Text("Password")
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundColor(Color.init(.label).opacity(0.75))
                        SecureField("Enter Your Password", text: $pass)
                        Divider()
                    }
                HStack{
                    Spacer()
                    
                    Button(action: {
                        
                    }){
                        Text("Forget Password?")
                            .foregroundColor(Color.gray.opacity(0.5))
                    }
                }
            }.padding(.horizontal, 6)
             
            Button(action:{
                signInWithEmail(email: self.user, password: self.pass){ (verified, status) in
                    if !verified {
                        self.msg = status
                        self.alert.toggle()
                    } else{
                        UserDefaults.standard.set(true, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                    }
                }
            }){
                Text("Sign In")
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 120)
                .padding()
            }.background(Color("bg"))
            .clipShape(Capsule())
                .padding(.top, 45)
            
            bottomView()
            
        }.padding()
            .alert(isPresented: $alert){
                Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
    }
}

struct bottomView: View{
    @State var show = false
    var body: some View{
        VStack{

            
            Text("(or)").foregroundColor(Color.gray.opacity(0.5)).padding(.top, 30)
            
            
            HStack{
                
                GoogleSignView().frame(width: 150, height: 55)
                
                Spacer()
                
                Button(action:{
                    self.show.toggle()
                }){
                    Image("fb")
                        .renderingMode(.original)
                        .padding()
                    
                }.clipShape(Circle())
                
                Spacer()
                
                Button(action:{
                    
                }){
                    Image("link")
                    .renderingMode(.original)
                    .padding()
                }.clipShape(Circle())
                
                Spacer()
                
                Button(action:{
                    
                }){
                    Image("twitter")
                    .renderingMode(.original)
                    .padding()
                }.clipShape(Circle())
            }.padding(.top, 25)
            
            HStack(spacing: 8){
                Text("Don't Have An Account?")
                    .foregroundColor(Color.gray.opacity(0.5))
                
                Button(action:{
                    self.show.toggle()
                    
                }){
                    Text("Sign up")
                }.foregroundColor(.blue)
            }.padding(.top, 20)
        }.sheet(isPresented: $show){
            Signup(show: self.$show)
        }
    }
}

struct Signup: View{
    @State var user = ""
    @State var pass = ""
    @State var alert = false
    @State var msg = ""
    @Binding var show: Bool
    
    var body: some View{
        VStack{
            Image("img")
            
            Text("Sign In")
                .fontWeight(.heavy)
                .font(.largeTitle)
                .padding([.top, .bottom], 20)
            
            VStack(alignment: .leading){
                VStack(alignment: .leading){
                    Text("Username")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(Color.init(.label).opacity(0.75))
                        HStack{
                            
                            TextField("Enter Your Username", text: $user)
                            .foregroundColor(Color.init(.label))
                            
                        }
                        
                        Divider()
                }.padding(.bottom, 15)
                VStack(alignment: .leading){
                        Text("Password")
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundColor(Color.init(.label).opacity(0.75))
                        SecureField("Enter Your Password", text: $pass)
                        Divider()
                    }
                HStack{
                    Spacer()
                    
                    Button(action: {
                        
                    }){
                        Text("Forget Password?")
                            .foregroundColor(Color.gray.opacity(0.5))
                    }
                }
            }.padding(.horizontal, 6)
             
            Button(action:{
                
                signUpWithEmail(email: self.user, password: self.pass){
                    (verified, status) in
                    if !verified{
                        self.msg = status
                        self.alert.toggle()
                    } else{
                        UserDefaults.standard.set(true, forKey: "status")
                        self.show.toggle()
                        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    }

                }
            }){
                Text("Sign Up")
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 120)
                .padding()
            }.background(Color("bg"))
            .clipShape(Capsule())
                .padding(.top, 45)
        }.padding()
            .alert(isPresented: $alert){
                Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
       
    }
}

struct GoogleSignView: UIViewRepresentable{
    func makeUIView(context: UIViewRepresentableContext<GoogleSignView>) -> GIDSignInButton {
        
        let button = GIDSignInButton()
        button.colorScheme = .dark
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        return button
        
    }
    func updateUIView(_ uiView: GoogleSignView.UIViewType, context: UIViewRepresentableContext<GoogleSignView>) {
        
    }
}

func signInWithEmail(email: String, password: String, completion: @escaping (Bool, String) -> Void){
    Auth.auth().signIn(withEmail: email, password: password){ (res, err) in
        if err != nil{
            completion(false, (err?.localizedDescription)!)
            return
        }
        completion(true, (res?.user.email)!)
        
    }
}

func signUpWithEmail(email: String, password: String, completion: @escaping (Bool, String) -> Void){
    Auth.auth().createUser(withEmail: email, password: password){(res, err) in
        if err != nil{
            completion(false, (err?.localizedDescription)!)
            return
        }
        completion(true, (res?.user.email)!)
        
    }
}

struct Home: View{
    var body: some View{
        VStack{
            Text("Home")
            Button(action:{try! Auth.auth().signOut()
                GIDSignIn.sharedInstance()?.signOut()
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                
            }){
                    Text("Logout")
                    
            }
            
        }
    }
}
