package com.ej.fishingmate.infofreeboard.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.UUID;
import java.util.Locale.Category;

import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.UploadContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.ej.fishingmate.infofreeboard.service.InfoFreeboardServiceImpl;
import com.ej.fishingmate.vo.InfoCategoryListVO;
import com.ej.fishingmate.vo.InfoCategoryVO;
import com.ej.fishingmate.vo.InfoFreeboardCommentVO;
import com.ej.fishingmate.vo.InfoFreeboardImageVO;
import com.ej.fishingmate.vo.InfoFreeboardVO;
import com.ej.fishingmate.vo.MemberVO;
import com.sun.mail.handlers.multipart_mixed;

@Controller
@RequestMapping("infofreeboard/*")
public class InfoFreeboardController {

	
	@Autowired
	private InfoFreeboardServiceImpl infofreeboardServiceimpl;
	
	@RequestMapping("infofreeboard.do")
	public String infofreeboard(Model model, @RequestParam(defaultValue="1") int info_category_no) {
									
			if(info_category_no != 1) {
				ArrayList<InfoCategoryVO> result = infofreeboardServiceimpl.getinfoCategoryList();
				ArrayList<HashMap<String, Object>> infofreeboardList=
						infofreeboardServiceimpl.getinfoFreeboardList(info_category_no);
					
			//ArrayList<InfoFreeboardVO> infoFreeboardList = infofreeboardServiceimpl.getinfoFreeboardList();
			    int contentCount = infofreeboardServiceimpl.InfoFreeboardTotalNo();
			   
			    		
				model.addAttribute("InfoCategoryVO", result);
				model.addAttribute("infofreeboardList",infofreeboardList);
			    model.addAttribute("categoryNo", info_category_no);
			    model.addAttribute("num",1);
			    model.addAttribute("contentCount",contentCount);
				
			    
			    
				return "infofreeboard/freeboard";
				
			}else {
				ArrayList<InfoCategoryVO> result =infofreeboardServiceimpl.getinfoCategoryList();
				ArrayList<HashMap<String, Object>> infofreeboardList = infofreeboardServiceimpl.getinfoallFreeboardList();
	
				int contentCount = infofreeboardServiceimpl.InfoFreeboardTotalNo();
				model.addAttribute("InfoCategoryVO", result);
				model.addAttribute("infofreeboardList",infofreeboardList);
				model.addAttribute("num",1);
				model.addAttribute("contentCount",contentCount);
				
				return "infofreeboard/freeboard";
			}
			
				
							
		}				
			
		
			
//				ArrayList<HashMap<String, Object>> result = infofreeboardServiceimpl.selectCategoryByFreeboardNo(info_category_no);
//				ArrayList<InfoCategoryVO> result2 = infofreeboardServiceimpl.getinfoCategoryList();
//				
//				model.addAttribute("freeboardList", result);
//				model.addAttribute("cotegoryList", result2);
//				
//				return "infofreeboard/freeboard";
//				
//			}
//			
			
			
		
		
		// ??????????????? ?????????
		@RequestMapping("writeinfofreeboard.do")
		public String writeinfofreeboard(Model model) {
			
			ArrayList<InfoCategoryVO> result = infofreeboardServiceimpl.getinfoCategoryList();
			
			model.addAttribute("infoCategoryList", result);
			model.addAttribute("num",1);
			
			
			return "infofreeboard/writeinfoContent";
		}
		
		@RequestMapping("writeinfoprocess.do")
		public String writeinfoProcess(InfoFreeboardVO infoFreeboardVO, HttpSession session, MultipartFile [] upload_files, int info_category_no) {
	
			
	//----------------------- ?????? ????????? ????????? ?????? ??????		
			
			ArrayList<InfoFreeboardImageVO> infofreeboardImageVOList=
					new ArrayList<InfoFreeboardImageVO>();
				
			
			if(upload_files != null) {
				for(MultipartFile upload_file : upload_files) {
					
					if(upload_file.isEmpty()) {
						continue;
					}
					
				
					String oriFileName = upload_file.getOriginalFilename();
					
					long cuttentTime= System.currentTimeMillis();
					UUID uuid = UUID.randomUUID();
					String uuidName= uuid.toString();
					String ext=oriFileName.substring(oriFileName.lastIndexOf("."));
					
					String randomFileName= uuidName+"_"+cuttentTime+ext;
					
					//?????? ??? ?????? ????????????
					Date date= new Date();
					SimpleDateFormat sdf= new SimpleDateFormat("yyyy/MM/dd");
					String newfolderName = sdf.format(date);
					
					String uploadFolderName = "C:/upload_files/"+newfolderName;
					
					File folder = new File(uploadFolderName);
					if(!folder.exists()) {
						folder.mkdirs();
					}
					
					String freeboardFileImageFileLocation =uploadFolderName+"/"+randomFileName;
					
					try {
						upload_file.transferTo(new File(freeboardFileImageFileLocation));
					}catch (Exception e) {
						e.printStackTrace();
					}
					
					InfoFreeboardImageVO infofreeboardImageVO=new InfoFreeboardImageVO();
					
					
					infofreeboardImageVO.setImage_location(newfolderName+"/"+randomFileName);
					infofreeboardImageVO.setImage_original_filename(oriFileName);
					
					infofreeboardImageVOList.add(infofreeboardImageVO);				
				}
			}
			MemberVO sessionUser = (MemberVO) session.getAttribute("sessionUser");
			
			int sessionNo = sessionUser.getMember_no();
			
			infoFreeboardVO.setMember_no(sessionNo);
			
			infofreeboardServiceimpl.writeinfoContent(infoFreeboardVO, infofreeboardImageVOList, info_category_no);
			
			
			
			return "redirect:./infofreeboard.do";
		}
		//--------------------------?????? ????????? ??????
		@RequestMapping("readinfofreeboard.do")
		public String readinfoPage(Model model, int info_freeboard_no ,HttpSession session) {
	
			MemberVO sessionUser = (MemberVO) session.getAttribute("sessionUser");
			if(sessionUser != null) {
				int member_no = sessionUser.getMember_no();
				int myRecommendCount = infofreeboardServiceimpl.getMyRecommendCount(info_freeboard_no,member_no);
				
				model.addAttribute("myRecommendCount",myRecommendCount);
			}
			int recommendCount = infofreeboardServiceimpl.getRecommendCount(info_freeboard_no);
			int commentCount = infofreeboardServiceimpl.getCommentCountByNo(info_freeboard_no);
			
			
			
			model.addAttribute("recommendCount" ,recommendCount);
			
			infofreeboardServiceimpl.updateinforeadcount(info_freeboard_no);
			
			HashMap<String , Object> infofreeboardVO = infofreeboardServiceimpl.getinfocontent(info_freeboard_no);
			//---------------------------?????? ??????
			ArrayList<HashMap<String, Object>> infofreeboardCommentList = infofreeboardServiceimpl.getinfoCommentBynO(info_freeboard_no);
			model.addAttribute("infofreeboardCommentList", infofreeboardCommentList);
			
			model.addAttribute("infofreeboardVO",infofreeboardVO);
			model.addAttribute("commentCount",commentCount);
			model.addAttribute("num",1);
			
			return "infofreeboard/readinfoContent";
		}
		 
		//--------------------------- ?????? ????????? ?????? ????????? ??????
		@RequestMapping("updateinfoContent.do")
		public String updateinfoContent(Model model , int info_freeboard_no) {
			
			HashMap<String , Object> map = infofreeboardServiceimpl.getinfocontent(info_freeboard_no);
			model.addAttribute("data",map);
			
			ArrayList<InfoFreeboardImageVO> result = infofreeboardServiceimpl.getimagebyfno(info_freeboard_no);
			model.addAttribute("getimageNo",result);
			model.addAttribute("num",1);
			
			return "infofreeboard/updateinfoContent";
		}
		
		//------------------------?????? ?????????  ?????? 
		@RequestMapping("updateinfoContentProcess.do")
		public String updateinfoContentProcess(InfoFreeboardVO infoFreeboardVO, MultipartFile [] upload_files) {
		
			System.out.println(infoFreeboardVO.getInfo_freeboard_no());
			int no=infoFreeboardVO.getInfo_freeboard_no();
			
		
			ArrayList<InfoFreeboardImageVO> infofreeboardImageVOList=
					new ArrayList<InfoFreeboardImageVO>();
				
			
			if(upload_files != null) {
				for(MultipartFile upload_file : upload_files) {
					
					if(upload_file.isEmpty()) {
						continue;
					}
					
				
					String oriFileName = upload_file.getOriginalFilename();
					
					long cuttentTime= System.currentTimeMillis();
					UUID uuid = UUID.randomUUID();
					String uuidName= uuid.toString();
					String ext=oriFileName.substring(oriFileName.lastIndexOf("."));
					
					String randomFileName= uuidName+"_"+cuttentTime+ext;
					
					//?????? ??? ?????? ????????????
					Date date= new Date();
					SimpleDateFormat sdf= new SimpleDateFormat("yyyy/MM/dd");
					String newfolderName = sdf.format(date);
					
					String uploadFolderName = "C:/upload_files/"+newfolderName;
					
					File folder = new File(uploadFolderName);
					if(!folder.exists()) {
						folder.mkdirs();
					}
					
					String freeboardFileImageFileLocation =uploadFolderName+"/"+randomFileName;
					
					try {
						upload_file.transferTo(new File(freeboardFileImageFileLocation));
					}catch (Exception e) {
						e.printStackTrace();
					}
					
					InfoFreeboardImageVO infofreeboardImageVO=new InfoFreeboardImageVO();
					
					
					infofreeboardImageVO.setImage_location(newfolderName+"/"+randomFileName);
					infofreeboardImageVO.setImage_original_filename(oriFileName);
					
					infofreeboardImageVOList.add(infofreeboardImageVO);				
				}
							
			}
		
			infofreeboardServiceimpl.updateinfoContent(infoFreeboardVO, infofreeboardImageVOList);
			
			return "redirect:./readinfofreeboard.do?info_freeboard_no="+no;
			
		}
		
		
		//-----------------------?????? ????????? ????????? ??????
		@RequestMapping("deleteContentImageProcess.do")
		public String deleteContentImageProcess(int image_no, int info_freeboard_no) {
			infofreeboardServiceimpl.deleteContentImage(image_no);
			
			return "redirect:./updateinfoContent.do?info_freeboard_no="+info_freeboard_no;
		}
		
		
		//-------------------------?????? ????????? ??????
		@RequestMapping("deleteinfoContentProcess.do")
		public String deleteinfoContentProcess(int info_freeboard_no) {
		
			infofreeboardServiceimpl.deleteinfoContent(info_freeboard_no);
			
			return "redirect:./infofreeboard.do";
		}
		
		//-------------------------?????? ????????? ?????? ??????
		@RequestMapping("writeinfoComment.do")
		public String writeinfoComment(InfoFreeboardCommentVO infoFreeboardCommentVO) {
			
			infofreeboardServiceimpl.writeinfoComment(infoFreeboardCommentVO);
			int infofreeboardNo=infoFreeboardCommentVO.getInfo_freeboard_no();
			
			return "redirect:./readinfofreeboard.do?info_freeboard_no="+infofreeboardNo;
			
		}
		@RequestMapping("modifyinfoCommentPage.do")
		public String modifyinfoCommentPage(Model model , int member_no, int info_comment_no) {
			
			InfoFreeboardCommentVO infoFreeboardCommentVO = infofreeboardServiceimpl.getinfoContentCommentBynO(member_no, info_comment_no);
			
			model.addAttribute("infofreeboardCommentVO",infoFreeboardCommentVO);
			model.addAttribute("num",1);
			return "infofreeboard/modifyinfoCommentPage";
		}
		
		
		//---------------------------?????? ????????? ?????? ?????? ????????????
		@RequestMapping("modifyinfoCommentProcess.do")
		public String modifyinfoCommentProcess(InfoFreeboardCommentVO infoFreeboardCommentVO) {
			
			
			infofreeboardServiceimpl.modifyinfoCommentByMnoAndCno(infoFreeboardCommentVO);
			
			
			return "redirect:./readinfofreeboard.do?info_freeboard_no="+infoFreeboardCommentVO.getInfo_freeboard_no();
		}
		//---------------------------?????? ????????? ?????? ?????? ????????????
		@RequestMapping("deleteinfoCommentProcess.do")
		public String deleteinfoCommentProcess(InfoFreeboardCommentVO infoFreeboardCommentVO) {
			
			int infofreeboardNo = infoFreeboardCommentVO.getInfo_freeboard_no();
			
			infofreeboardServiceimpl.deleteinfoCommentByMno(infoFreeboardCommentVO);
			
			return"redirect:./readinfofreeboard.do?info_freeboard_no="+infofreeboardNo;
		}
		
		//---------------------- ?????? ????????? ?????? ----------------------

		@RequestMapping("recommendProcess.do")
		public String recommendProcess(HttpSession session, int info_freeboard_no) {
			
			MemberVO sessionUser = (MemberVO) session.getAttribute("sessionUser");
			int member_no =sessionUser.getMember_no();
			
			infofreeboardServiceimpl.recommend(info_freeboard_no, member_no);
			
			
			System.out.println(info_freeboard_no); 
			return "redirect:./readinfofreeboard.do?info_freeboard_no="+info_freeboard_no;
		}
		//----------------------------???????????? ?????????-------------------

//		@RequestMapping("infoCategoryProcess.do")
//		public String categoryProcess(int info_category_no) {
//			
//			infofreeboardServiceimpl.selectCategoryByFreeboardNo(info_category_no);
//					
//			return  "redirect:./readinfofreeboard.do?info_category_no="+info_category_no;
//		}
		
		
		
		@RequestMapping("infopage.do")
		public String infopage(Model model) {
			model.addAttribute("num",1);
			
			return "infofreeboard/infopage";
		}
	//?????? ????????? ??????

@RequestMapping("lotto45.do")
public String lotto() {
	
	return "infofreeboard/lotto45";
}
@RequestMapping("lottoProcess.do")
public void lottoProcess(int lotto_no) {
	
	 infofreeboardServiceimpl.insertLottoNo(lotto_no);
}
@RequestMapping("battinglotto45.do")
public String battinglotto45() {
	
	return "infofreeboard/battinglotto45";
}

}
