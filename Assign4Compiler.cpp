#include <bits/stdc++.h>
#include<iostream>
#include<vector>
#include<cstring>
#include<map>
using namespace std;

 map<char, map<char,string> > p_table;
stack<char> s;
	
bool is_terminal (char s)
{
	if(s == 'E' || s=='T' || s=='M' || s=='N' || s=='F')
		return false;
	else 
		return true;
}
void push_reverse ( string arr)
{
	int n = arr.size();
	for (int i = n-1; i>=0; i--)
	{	if(arr[i]!='e')
		{	s.push(arr[i]);
			cout<<arr[i]<<" pushed to the stack!"<<endl;
		}
	}
}
bool parse(vector<char> exp)
{
	int ptr = 0;
	s.push('$');
	s.push('E');
	char ch;
	while(!s.empty())
	{	
		ch = exp[ptr];
		cout<<"ch = "<<ch<<endl;
		char ch_s = s.top();
		cout<<"ch_s = "<<ch_s<<endl;
		if(is_terminal(ch_s))
		{	
			if(ch_s == ch)
			{
				s.pop();
				ptr++;
				cout<<ch<<" cancelled"<<endl;
				if(ch=='$')
					return true;
			}
			else
				return false;
		}
		else // Non terminal
		{	
			cout<<"Non-terminal on stack - "<<ch_s<<endl;
			
			if(p_table[ch_s].find(ch)!= p_table[ch_s].end()) // Found
            		{	 
            			cout<<"Entry found in table for "<<ch_s<<", "<<ch<<endl;
                		s.pop();
                		push_reverse(p_table[ch_s][ch]);
            		}
            		else  if(p_table[ch_s].find(ch)==p_table[ch_s].end())// Not found
            		{	
            			cout<<"Entry not found in table for "<<ch_s<<", "<<ch<<endl;
            			return false;
            		}
		}
		if(s.empty())
			cout<<"Stack Empty"<<endl;
		else
			cout<<"Stack not empty"<<endl;
	}
	return true; 	
}

int main()
{
	p_table['E']['i'] = "TM";	p_table['E']['('] = "TM";	p_table['M']['+'] = "+TM";	p_table['M'][')'] = "ME";	p_table['M']['$'] = "e";	
	p_table['T']['i'] = "FN";	p_table['T']['('] = "FN";	p_table['N']['+'] = "e";	p_table['N']['*'] = "*FN";	p_table['N'][')'] = "e";	
	p_table['N']['$'] = "e";	p_table['F']['i'] = "i";	p_table['F']['('] = "(E)";
	
	vector<char> exp;
	while(1)
	{	
		char s;
		cin>>s;
		exp.push_back(s);
		if(s =='$')
			break;
	}
	for (int i=0; i<exp.size(); i++)
		cout<<exp[i]<<" ";
	
	bool res = parse(exp);
    
    if(res == true)
    	cout<<"Accepted :)"<<endl;
    else if(res == false)
    	cout<<"Not Accepted :("<<endl;

	return 0;
}
