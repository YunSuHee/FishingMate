package com.ej.fishingmate.dice.controller;

import java.text.DecimalFormat;
import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ej.fishingmate.dice.service.DiceServiceImpl;
import com.ej.fishingmate.vo.DiceGameVO;
import com.ej.fishingmate.vo.MemberVO;

@Controller
@RequestMapping("/dice/*")
public class DiceController {
	
	@Autowired
	private DiceServiceImpl diceService;
	
	@RequestMapping("dicePage.do")
	public String dicePage(){
		
		return "dice/diceGame";
	}
	DecimalFormat comma = new DecimalFormat("###,###");

	@ResponseBody
	@RequestMapping("diceGame.do")
	public HashMap<String,Object> diceGame(HttpSession session) {
		HashMap<String,Object> map = new HashMap<String,Object>(); 
		
		MemberVO memberVO = (MemberVO) session.getAttribute("sessionUser");
		
		
		
		int currentJackpotMoney = diceService.getCurrentJackpotMoney();
		int myLevelValue = diceService.getMyLevelValue(memberVO.getMember_no());
		
		comma.format(myLevelValue);
		comma.format(currentJackpotMoney);
		
		map.put("currentJackpotMoney", comma.format(currentJackpotMoney));		
		map.put("myLevelValue", comma.format(myLevelValue));
		
		return map;		
	}

	@ResponseBody
	@RequestMapping("throwDice.do")
	public HashMap<String,Object> throwDice(HttpSession session , DiceGameVO diceGameVO , @RequestParam(defaultValue = "0") int bet2,@RequestParam(defaultValue = "0")int bet3,
																						  @RequestParam(defaultValue = "0")int bet23,@RequestParam(defaultValue = "0")int bet1) {
		HashMap<String,Object> map = new HashMap<String,Object>(); 
		
		int currentJackpotMoney = diceService.getCurrentJackpotMoney();
		
		comma.format(currentJackpotMoney);
		
		map.put("currentJackpotMoney", comma.format(currentJackpotMoney));
		
		
		int myTotalBetMoney = bet1+bet2+bet3+bet23;
		
		comma.format(myTotalBetMoney);
		
		MemberVO memberVO = (MemberVO) session.getAttribute("sessionUser");
		diceGameVO.setMember_no(memberVO.getMember_no());
		
		//?????? ?????? ?????????...?????????... ?????? X
		int myLevelValue = diceService.getMyLevelValue(memberVO.getMember_no());
		
		comma.format(myLevelValue);
		
		map.put("myLevelValue", comma.format(myLevelValue));
		
		if(myLevelValue < myTotalBetMoney) {
			
			map.put("result", "fail");
			map.put("reason", "????????? ???????????????.");
			
			return map;
		}
		
		
		//diceService.insertDiceGame(diceGameVO);
		
		//??????????????
		
		
		int dice1 = (int)(Math.random()*6) + 1;
		int dice2 = (int)(Math.random()*6) + 1;
		int dice3 = (int)(Math.random()*6) + 1;
		int dice4 = (int)(Math.random()*6) + 1;
		int dice5 = (int)(Math.random()*6) + 1;
		
		//??????		
		int diceAll = dice1+dice2+dice3+dice4+dice5;
		int one = 0;
		
		int totalPrice = 0;
		map.put("bet2", "lose");
		map.put("bet3", "lose");
		map.put("bet23", "lose");
		map.put("bet1", "lose");
		
		
		if (diceAll % 2 ==0) { // 2?????????
			//2??????..
			map.put("bet2", "win");
			totalPrice += (int)(bet2 * 2);
		}
		if (diceAll % 3 == 0) { // 3??? ??????
			//2.5??????
			map.put("bet3", "win");
			totalPrice += (int)(bet3 * 2.5);
		}
		if (diceAll%2!=0 && diceAll%3!=0) { //2,3??? ?????? ?????? ??????
			//2.5??????..
			map.put("bet23", "win");
			totalPrice += (int)(bet23 * 2.5);
		}
		//????????? 1 ?????? ????????? ??????
		if (dice1 == 1) {
			map.put("bet1", "win");
			one++;
		}
		if (dice2 == 1) {
			map.put("bet1", "win");
			one++;
		}
		if (dice3 == 1) {
			map.put("bet1", "win");
			one++;
		}
		if (dice4 == 1) {
			map.put("bet1", "win");
			one++;
		}
		if (dice5 == 1) {
			map.put("bet1", "win");
			one++;
		}
		map.put("bet1", "win");
		totalPrice += (int)(bet1 * one);
		// 1????????? ???
		 
		if (diceAll <= 5){ // ??? 1 ??????
			
			//?????? ????????? ????????????... ??? ????????? ????????????... ?????? ????????? 0?????? ??????....
			diceService.calculateMemberLevelValue(currentJackpotMoney,memberVO.getMember_no());
			diceService.initJackpotMoney();
			map.put("Great", true);			
			map.put("currentJackpotMoney",0);
			
		}else{ 
			map.put("Great", false);
		}
	
		
		
		//?????? ??????.... ???????????? ????????????....
		if(totalPrice - myTotalBetMoney > 0) {
			//?????????...
			diceService.calculateMemberLevelValue((totalPrice - myTotalBetMoney) * 90 / 100 , memberVO.getMember_no());
			//10?????? ????????????
			diceService.increaseJackPot((totalPrice - myTotalBetMoney) * 10 / 100);
			
			
		}else {
			//????????????...
			diceService.calculateMemberLevelValue(totalPrice - myTotalBetMoney , memberVO.getMember_no());
		}
		
		
		//?????? ??????
	    int plma = (totalPrice-myTotalBetMoney);
	    map.put("plma", plma);
		
		map.put("dice1", dice1);
		map.put("dice2", dice2);
		map.put("dice3", dice3);
		map.put("dice4", dice4);
		map.put("dice5", dice5);
		
		map.put("winMoney", totalPrice);
		map.put("totalBetMoney", myTotalBetMoney);
		
		//???????????? ????????? ?????????????????....		
		
		//DB ????????? ?????? ?????????... ??????... ???????????? ????????? ???....
		

		
		
		return map;
		
	}
	
	
}
