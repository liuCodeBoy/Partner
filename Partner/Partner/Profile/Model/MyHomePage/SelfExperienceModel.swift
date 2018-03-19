//
//  SelfExperienceModel.swift
//  Partner
//
//  Created by YJ on 2018/3/17.
//

import MJExtension

class EntrepreneurshipModel: NSObject {
    
    @objc var id                    : NSNumber?
    @objc var entrProjName          : String?
    @objc var entrRole              : String?
    @objc var entrIndustry          : String?
    @objc var entrArea              : String?
    @objc var entrDate              : String?
    @objc var beginDate             : String?
    @objc var entrDateEnd           : String?
    @objc var entrPartnership       : String?
    @objc var entrTeamNum           : String?
    @objc var entrFinancingScale    : String?
    @objc var entrFullTime          : NSNumber? //全职创业，1是 0否
    @objc var entrDesc              : String?

}

class WorkExperienceModel: NSObject {
    
    @objc var id                    : NSNumber?
    @objc var jobCompName           : String?
    @objc var jobName               : String?
    @objc var jobOnTime             : String?
    @objc var beginDate             : String?
    @objc var jobOnTimeEnd          : String?
    @objc var jobDesc               : String?
    
}

class EducationExperienceModel: NSObject {
    
    @objc var id                    : NSNumber?
    @objc var eduSchool             : String?
    @objc var eduDegree             : String?
    @objc var eduSpecialty          : String?
    @objc var eduDate               : String?
    @objc var beginDate             : String?
    @objc var eduDateEnd            : String?
    @objc var eduDesc               : String?

}
